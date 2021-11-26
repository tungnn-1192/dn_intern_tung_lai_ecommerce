(function ($) {
  $(".select-status").on("change", function () {
    let btn = $(this).closest("tr").find(".btn-update");
    if (isDefaultSelectOption(this)) {
      btn.addClass("disabled");
    } else {
      btn.removeClass("disabled");
      setStatusParam(btn, this.value);
    }
  });
  function isDefaultSelectOption(selectElm) {
    return selectElm.firstElementChild.value == selectElm.value;
  }
  function setStatusParam(jBtn, status) {
    let previousUrl = jBtn.attr("href");
    jBtn.attr("href", `${getUrlPath(previousUrl)}?status=${status}`);
  }
  function getUrlPath(url) {
    let index = url.indexOf("?");
    if (index < 0) return url;
    else return url.substring(0, index);
  }
})(jQuery);
