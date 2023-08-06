window.addEventListener("message",function(event) {
    let data = event.data
    if (data.action == "show") {
        DisplayUI(data.config)
    } else if (data.action == "force") {
        closeUI()
    }
})


DisplayUI = function(data){
    $(".card-container").empty()
    $("body").css("opacity", 1);
    $.each(data, function(key,value) {
        let content = `
        <div class="card">
        <div class="locationImg" style="background-image: url(${value.cardImg})">

        </div>
        <div class="infoInput">
            <div class="infoHead">
                ${value.locationLabel}:
            </div>
            <div class="infoFooter">
            ${value.locationDesc}
            </div>
            <div class="infoHead">
                Number of people in the area:
            </div>
            <div class="infoFooter">
            Currently, <strong style="color:#CA9B54">${value.playerCountInArea}</strong> player in the ${value.locationLabel}.
        </div>
        </div>
        <div class="teleportBtn" data-key="${key}">
            TELEPORT TO THE ${value.locationLabel}
        </div>
    </div>`
    $(".card-container").append(content)
    })
}


closeUI = function() {
    $("body").css("opacity", 0);
}

$(document).on("click", ".teleportBtn", function () {
    console.log("selectbtn clicked" + $(this).data("key"));
    $.post(
      "https://cas-fastteleport/nuiFetch",
      JSON.stringify({
        key: Number($(this).data("key")) + 1,
      }),
      function (res) {
        if (res) {
          console.log("success")
        }
      }
    );
  });
