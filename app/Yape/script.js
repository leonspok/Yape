(function() {
    // MARK: - Setup -

    const documentUID = guid()

    const observingConfig = { attributes: false, childList: true, characterData: false };
    const observer = new MutationObserver(exportVideosIfNeeded)
    observer.observe(document, observingConfig)

    safari.self.addEventListener("message", handleMessage)

    var videosFoundAtLeastOnce = false

    // MARK: - Messaging -

    function handleMessage(event) {
        const messageHandlers = {
            "export_videos": getVideosRequestHandler,
            "highlight_video": highlightVideoRequestHandler,
            "remove_highlight": removeHighlightRequestHandler,
            "scroll_to_video": scrollToVideoRequestHandler,
            "enable_pip": enablePiPRequestHandler,
            "move_fullscreen": fullscreenRequestHandler,
        }
        
        const messageName = event.name
        const params = event.message
        
        let handler = messageHandlers[messageName]
        if (handler != undefined) {
            handler(params)
        }
    }

    function sendMessage(name, message) {
        var messageObject = {}
        messageObject.document = {
            "uid": documentUID,
            "location": document.URL
        }
        if (document.title != undefined, document.title.length > 0) {
            messageObject.document.title = document.title
        }
        if (message != undefined) {
            messageObject.message = message
        }
        safari.extension.dispatchMessage(name, messageObject)
    }

    // MARK: - Request Handlers -

    function getVideosRequestHandler(params) {
        exportVideosIfNeeded()
    }

    function exportVideos(forced) {
    	const videos = getWebpageVideos()
        let items = []
        for (let i = 0; i < videos.length; i++) {
            let video = videos[i]
            let item = {};
            item["uid"] = video.getAttribute("data-yape-uuid")
            item["is_playing"] = !video.paused
            if (video.title != undefined && video.title.length > 0) {
                item["title"] = video.title
            } else {
                item["title"] = "Video #" + (i + 1)
            }
            if (video.duration != undefined &&
                video.duration != null &&
                video.duration != Number.POSITIVE_INFINITY &&
                video.duration != Number.NEGATIVE_INFINITY &&
                video.duration != Number.NaN) {
                item["duration"] = video.duration
            }
            items.push(item)
        }
        let info = {
            "videos": items
        }
        if (items.length > 0 || forced) {
        	if (items.length > 0) {
        		videosFoundAtLeastOnce = true
        	}
        	sendMessage("videos_list", info)
        }
    }

    function exportVideosIfNeeded() {
        exportVideos(videosFoundAtLeastOnce)
    }

    function highlightVideoRequestHandler(params) {
        const video = getVideo(params["uid"])
        if (video != null) {
            highlightElement(video)
        }
    }

    function removeHighlightRequestHandler(params) {
        removeHightlight()
    }

    function scrollToVideoRequestHandler(params) {
        const video = getVideo(params["uid"])
        if (video != null) {
            video.scrollIntoView({ "behavior": "smooth", "block": "start" })
            window.scrollBy(0, -200)
        }
    }

    function enablePiPRequestHandler(params) {
        const video = getVideo(params["uid"])
        if (video != null) {
            enablePiP(video)
        }
    }
    
    function fullscreenRequestHandler(params) {
        const video = getVideo(params["uid"])
        if (video != null) {
            fullscreen(video)
        }
    }

    // MARK: - Page Actions -

    function getVideo(uid) {
        const videos = getWebpageVideos()
        for (let i = 0; i < videos.length; i++) {
            const video = videos[i]
            if (video.getAttribute("data-yape-uuid") == uid) {
                return video
            }
        }
        return null
    }

    function getWebpageVideos() {
        const elements = document.getElementsByTagName("video")
        var elementsToExport = []
        for (let i = 0; i < elements.length; i++) {
            const element = elements[i]
            if (element.webkitSupportsPresentationMode == undefined || !element.webkitSupportsPresentationMode("picture-in-picture") ||
                element.readyState < 3 ||
                element.loop) {
                continue
            }
            if (element.getAttribute("data-yape-uuid") == undefined) {
                element.setAttribute("data-yape-uuid", guid())
                
                element.addEventListener("play", exportVideosIfNeeded, { "passive": true })
                element.addEventListener("pause", exportVideosIfNeeded, { "passive": true })
                element.addEventListener("durationchange", exportVideosIfNeeded, { "passive": true })
                element.addEventListener("canplay", exportVideosIfNeeded, { "passive": true })
            }
            elementsToExport.push(element)
        }
        return elementsToExport
    }

    function enablePiP(video) {
        video.webkitSetPresentationMode("picture-in-picture")
    }
    
    function fullscreen(video) {
        video.requestFullscreen()
    }

    function highlightElement(element) {
        const rect = element.getBoundingClientRect()
        const bodyRect = document.body.getBoundingClientRect()
        let overlay = document.createElement("div")
        overlay.id = "yape-overlay"
        overlay.style.backgroundColor = "rgba(0, 0, 255, 0.3)"
        overlay.style.position = "absolute"
        overlay.style.top = (rect.top - bodyRect.top) + "px"
        overlay.style.left = (rect.left - bodyRect.left) + "px"
        overlay.style.width = rect.width + "px"
        overlay.style.height = rect.height + "px"
        overlay.style.zIndex = 1000
        document.body.appendChild(overlay)
    }

    function removeHightlight() {
        const overlay = document.getElementById("yape-overlay")
        if (overlay != null && overlay.parentElement != undefined && overlay.parentElement != null) {
            overlay.parentElement.removeChild(overlay)
        }
    }

    // MARK: - Helpers -

    function guid() {
        function s4() {
            return Math.floor((1 + Math.random()) * 0x10000)
            .toString(16)
            .substring(1);
        }
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
    }
})()



