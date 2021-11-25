(function ($) {
  /**
   * Toggle parent category: show subcategories
   */
  $(".toggle-down-wrapper").each((indx, elm) => {
    elm = $(elm);
    let main = $(".toggle-down-main", elm);
    let content = $(".toggle-down-content", elm);
    main.on("click", () => content.slideToggle(400));
  });

  function beautifyNumber(x) {
    return x.toLocaleString("de-DE");
  }

  $(".price-range-wrap").each((indx, elm) => {
    elm = $(elm);
    let slider = $(".price-range", elm);
    let inputs = $(".price-input input", elm);
    let range = [slider.data("min"), slider.data("max")];
    let initials = [slider.data("start"), slider.data("end")];
    let config = {
      range: true,
      min: range[0],
      max: range[1],
      values: initials,
      step: slider.data("step") || 1,
      slide: (e, ui) => {
        inputs.eq(ui.handleIndex).val(beautifyNumber(ui.value));
      },
    };
    slider.slider(config);
    inputs.each((indx) => {
      inputs.eq(indx).val(beautifyNumber(initials[indx]));
    });
  });
  $('form.before-submit input[type="submit"]').on("click", function (event) {
    let arr = $(".to-int");
    for (let i = 0; i < arr.length; ++i) {
      arr[i].value = arr[i].value.replaceAll(".", "");
    }
  });
})(jQuery);
