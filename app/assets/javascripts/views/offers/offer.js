function Offer(aContainer) {
  'use strict';

  var _container = aContainer,
    _domCounter = _container.find('[data-container="countdown"]'),

    _endsAt = _domCounter.data('ends-at'),
    _endsAtLabel = _domCounter.data('ends-at-label'),
    _expiredLabel = _domCounter.data('expired-label'),

    countDownInterval = null,

    UPDATE_COUNTDOWN_INTERVAL = 1000;


  // private

  function _setCountDown() {
    if (_endsAt == null) {
      clearInterval(countDownInterval);
      return;
    }

    var countDownDate= new Date(_endsAt).getTime(),
        now = new Date().getTime(),
        distance = countDownDate - now;

    if (distance < 0) {
      clearInterval(countDownInterval);
      _domCounter.html(_expiredLabel);
    } else {

      _domCounter.html(_buildCountDownHtml(distance));
    }
  }

  function _buildCountDownHtml(distance) {
    var days = Math.floor(distance / (1000 * 60 * 60 * 24)),
        hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
        minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60)),
        seconds = Math.floor((distance % (1000 * 60)) / 1000);

    return _endsAtLabel + ' ' + days + "d " + hours + "h " + minutes + "m " + seconds + "s ";
  }

  function _init() {
    countDownInterval = setInterval(_setCountDown, UPDATE_COUNTDOWN_INTERVAL);
  }

  _init();
}
