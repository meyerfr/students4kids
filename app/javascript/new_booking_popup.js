function activatePopup() {
  const popup = document.getElementById('myModal');
  if (popup) {
    const allPopupButton = document.querySelectorAll("button[data-toggle='modal']");
    allPopupButton.forEach((popupButton) => {
      popupButton.addEventListener('click', function(e){
        popup.querySelector('.modal-body').append("<%= escape_javascript(render partial: 'new', locals: { items: @selected } ) %>");
        // popup.querySelector('.modal-body').append("<%= j render(:partial => 'booking/_new') %>");
      })
    })
  }
}

export { activatePopup }
