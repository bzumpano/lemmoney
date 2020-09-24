//= require ./offer

$(function() {
  'use strict';

  function _init() {
    $('[data-container="offer"]').each(function() {
      new Offer($(this));
    });
  }

  _init();
});
