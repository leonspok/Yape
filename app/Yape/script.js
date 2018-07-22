safari.self.addEventListener("message", handleMessage);

function handleMessage(event) {
    const messageHandlers = {
        "videos/get": getVideosRequestHandler,
        "videos/highlight": toggleHighlightRequestHandler,
        "videos/enable_pip": enablePiPRequestHandler
    }
    
    const uid = event.name
    const requestName = event.message["request_name"]
    const params = event.message["params"]
    
    let handler = messageHandlers[requestName]
    if (handler != undefined) {
        handler(params, function(response) {
            if (response == null) {
                safari.extension.dispatchMessage(uid)
            } else {
                safari.extension.dispatchMessage(uid, response)
            }
        })
    } else {
        safari.extension.dispatchMessage(uid)
    }
}

// MARK: - Request Handlers -

function getVideosRequestHandler(params, callback) {
    const videos = getWebpageVideos()
    let items = []
    for (let i = 0; i < videos.length; i++) {
        let video = videos[i]
        let item = {};
        item["uid"] = video.getAttribute("data-yape-uuid")
        item["is_playing"] = !video.paused
        if (video.title != undefined) {
            item["title"] = video.title
        } else {
            item["title"] = "Video #" + i
        }
        items.push(item)
    }
    callback({ "videos": items })
}

function toggleHighlightRequestHandler(params, callback) {
    const video = getVideo(params["uid"])
    if (video != null) {
        if (params["highlight"]) {
            highlightElement(video)
        } else {
            removeHightlight(video)
        }
    }
    callback(null)
}

function enablePiPRequestHandler(params, callback) {
    const video = getVideo(params["uid"])
    if (video != null) {
        enablePiP(video)
    }
    callback(null)
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
    for (let i = 0; i < elements.length; i++) {
        const element = elements[i]
        if (element.getAttribute("data-yape-uuid") == undefined) {
            element.setAttribute("data-yape-uuid", guid())
        }
    }
    return elements
}

function enablePiP(video) {
    video.webkitSetPresentationMode("picture-in-picture")
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

function removeHightlight(element) {
    const overlay = document.getElementById("yape-overlay")
    overlay.parentElement.removeChild(overlay)
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



