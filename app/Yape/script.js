safari.self.addEventListener("message", handleMessage);

function handleMessage(event) {
    const messageHandlers = {
        "export_videos": getVideosRequestHandler,
        "toggle_highlight": toggleHighlightRequestHandler,
        "enable_pip": enablePiPRequestHandler
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
        items.push(item)
    }
    let info = {
        "videos": items
    }
    sendMessage("videos_list", info)
}

function toggleHighlightRequestHandler(params) {
    const video = getVideo(params["uid"])
    if (video != null) {
        if (params["highlight"]) {
            highlightElement(video)
        } else {
            removeHightlight(video)
        }
    }
}

function enablePiPRequestHandler(params) {
    const video = getVideo(params["uid"])
    if (video != null) {
        enablePiP(video)
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
    for (let i = 0; i < elements.length; i++) {
        const element = elements[i]
        if (element.webkitSupportsPresentationMode == undefined || !element.webkitSupportsPresentationMode("picture-in-picture")) {
            continue
        }
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
    const document = element.ownerDocument
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
    const document = element.ownerDocument
    const overlay = document.getElementById("yape-overlay")
    if (overlay.parentElement != undefined) {
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



