function activatePopup() {
  const popup = document.getElementById('myModal');
  if (popup) {
    const allPopupButton = document.querySelectorAll("a[data-toggle='modal']");
    allPopupButton.forEach((popupButton) => {
      popupButton.addEventListener('click', function(e){
        var availability_times = e.currentTarget.previousElementSibling.innerHTML
        popup.querySelector('.modal-body').innerHTML = availability_times;
        var availability_id = e.currentTarget.dataset.availability;
        var sitter_id = e.currentTarget.dataset.sitter;
        var submit_button_href = popup.querySelector('#submit-booking').href
        popup.querySelector('#submit-booking').setAttribute('href', `${submit_button_href}&booking%5Bavailability_id%5D=${availability_id};booking%5Bsitter_id%5D=${sitter_id}`)
        // popup.querySelector('.modal-body').append("<%= j render(:partial => 'booking/_new') %>");
      })
    })
  }
}

export { activatePopup }
