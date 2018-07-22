document.addEventListener("DOMContentLoaded", function(event) {
    safari.extension.dispatchMessage("Hello World!");
});

safari.self.addEventListener("message", handleMessage);

function handleMessage(event) {
    safari.extension.dispatchMessage("Received event");
    console.log(event.name);
    console.log(event.message);
    if (event.name == "")
}

function getVideoItemsForExport() {
    let videos = getWebpageVideos()
    let items = []
    for (let i = 0; i < videos.length(); i++) {
        let video = videos[i]
        let item = {};
        item["uid"] = video.getAttribute("--data-yape-uuid")
        if (video.title != undefiner) {
            item["title"] = video.title
        } else {
            item["title"] = "Video #" + i
        }
        items.push(item)
    }
    return items
}

function getWebpageVideos() {
    let elements = document.getElementsByTagName("video")
    for (element in elements) {
        if (element.getAttribute("--data-yape-uuid") == undefined) {
            element.setAttribute("--data-yape-uuid", guid())
        }
    }
    return elements
}

function enablePiP(video) {
    video.webkitSetPresentationMode('picture-in-picture')
}

function addInnerShadow(element) {
    if (element.style.boxShadow != undefined) {
        element.setAttribute("--data-old-shadow", element.style.boxShadow)
    }
    element.style.boxShadow = "inset 0 0 10px red"
}

function removeInnerShadow(element) {
    let oldShadow = element.getAttribute("--data-old-shadow")
    if (oldShadow != undefined) {
        element.style.boxShadow = oldShadow
    } else {
        element.style.boxShadow = "none"
    }
}

// Helpers

function guid() {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000)
        .toString(16)
        .substring(1);
    }
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
}



