/// JavaScript functions for bottom sheet SL/TP management
class BottomSheetJsFunctions {
  static const String functions = '''
// ── Bottom Sheet Management ───────────────────────────────────────
function openBottomSheet(positionId) {
  selectedPositionId = positionId;
  _renderSheet(positionId);
  
  document.getElementById('bs-overlay').style.display = 'block';
  requestAnimationFrame(function() {
    document.getElementById('bottom-sheet').classList.add('open');
  });
}

function closeBottomSheet() {
  document.getElementById('bottom-sheet').classList.remove('open');
  document.getElementById('bs-overlay').style.display = 'none';
  selectedPositionId = null;
}

function _renderSheet(positionId) {
  const pos = activePositions[positionId];
  const isBuy = pos.isBuy;
  const slOff = !pos.slEnabled;
  const tpOff = !pos.tpEnabled;
  
  document.getElementById('bottom-sheet').innerHTML =
    '<div class="bs-handle-row"><div class="bs-handle"></div></div>' +
    '<div class="bs-header">' +
      '<div class="bs-left">' +
        '<span class="bs-instrument">' + pos.label.split('#')[0].trim() + '</span>' +
        '<span class="bs-side-badge ' + (isBuy ? 'bs-side-buy' : 'bs-side-sell') + '">' +
          (isBuy ? '▲ BUY' : '▼ SELL') + ' &nbsp;·&nbsp; #' + positionId +
        '</span>' +
      '</div>' +
      '<div class="bs-entry-col">' +
        '<span class="bs-entry-label">Entry</span>' +
        '<span class="bs-entry-price">' + pos.entryPrice.toFixed(dotPosition) + '</span>' +
      '</div>' +
    '</div>' +

    // SL Row
    '<div class="sltp-row ' + (slOff ? 'disabled-row' : '') + '">' +
      '<div class="sltp-color-bar sl-bar"></div>' +
      '<div class="sltp-info">' +
        '<div class="sltp-title sl-title">Stop Loss</div>' +
        '<div class="sltp-price-row">' +
          '<input id="sl-input-' + positionId + '" class="sltp-price-input sl-price-input"' +
            ' type="number" step="' + pip + '" value="' + pos.slPrice.toFixed(dotPosition) + '"' +
            (slOff ? ' disabled' : '') +
            ' onchange="onSLInputChange(' + positionId + ',this.value)"/>' +
          '<span class="sltp-pip-label" id="sl-pips-' + positionId + '"></span>' +
        '</div>' +
      '</div>' +
      '<div class="sltp-step-col">' +
        '<button class="step-btn-sm"' + (slOff ? ' disabled' : '') + 
          ' onclick="adjustSL(' + positionId + ',1)">+</button>' +
        '<button class="step-btn-sm"' + (slOff ? ' disabled' : '') + 
          ' onclick="adjustSL(' + positionId + ',-1)">−</button>' +
      '</div>' +
      '<div class="toggle-wrap">' +
        '<button class="toggle-switch ' + (pos.slEnabled ? 'on-sl' : '') + '" ' +
          'onclick="toggleSL(' + positionId + ')">' +
          '<div class="toggle-knob"></div></button>' +
      '</div>' +
    '</div>' +

    // TP Row
    '<div class="sltp-row ' + (tpOff ? 'disabled-row' : '') + '">' +
      '<div class="sltp-color-bar tp-bar"></div>' +
      '<div class="sltp-info">' +
        '<div class="sltp-title tp-title">Take Profit</div>' +
        '<div class="sltp-price-row">' +
          '<input id="tp-input-' + positionId + '" class="sltp-price-input tp-price-input"' +
            ' type="number" step="' + pip + '" value="' + pos.tpPrice.toFixed(dotPosition) + '"' +
            (tpOff ? ' disabled' : '') +
            ' onchange="onTPInputChange(' + positionId + ',this.value)"/>' +
          '<span class="sltp-pip-label" id="tp-pips-' + positionId + '"></span>' +
        '</div>' +
      '</div>' +
      '<div class="sltp-step-col">' +
        '<button class="step-btn-sm"' + (tpOff ? ' disabled' : '') + 
          ' onclick="adjustTP(' + positionId + ',1)">+</button>' +
        '<button class="step-btn-sm"' + (tpOff ? ' disabled' : '') + 
          ' onclick="adjustTP(' + positionId + ',-1)">−</button>' +
      '</div>' +
      '<div class="toggle-wrap">' +
        '<button class="toggle-switch ' + (pos.tpEnabled ? 'on-tp' : '') + '" ' +
          'onclick="toggleTP(' + positionId + ')">' +
          '<div class="toggle-knob"></div></button>' +
      '</div>' +
    '</div>' +

    // Confirm Button
    '<div class="bs-confirm-row">' +
      '<button class="bs-confirm-btn" id="confirm-btn-' + positionId + '"' +
        (slOff && tpOff ? ' disabled' : '') +
        ' onclick="confirmSlTp(' + positionId + ')">Confirm</button>' +
    '</div>';

  _refreshPipLabels(positionId);
}

// ── Toggle SL/TP ──────────────────────────────────────────────────
function toggleSL(positionId) {
  const pos = activePositions[positionId];
  pos.slEnabled = !pos.slEnabled;
  
  if (pos.slEnabled) {
    pos.slLine = candlestickSeries.createPriceLine({
      price: pos.slPrice,
      color: '#FF5252',
      lineWidth: 2,
      lineStyle: LightweightCharts.LineStyle.Dashed,
      axisLabelVisible: true,
      title: 'SL',
    });
  } else {
    if (pos.slLine) {
      candlestickSeries.removePriceLine(pos.slLine);
      pos.slLine = null;
    }
  }
  
  _renderSheet(positionId);
}

function toggleTP(positionId) {
  const pos = activePositions[positionId];
  pos.tpEnabled = !pos.tpEnabled;
  
  if (pos.tpEnabled) {
    pos.tpLine = candlestickSeries.createPriceLine({
      price: pos.tpPrice,
      color: '#4CAF50',
      lineWidth: 2,
      lineStyle: LightweightCharts.LineStyle.Dashed,
      axisLabelVisible: true,
      title: 'TP',
    });
  } else {
    if (pos.tpLine) {
      candlestickSeries.removePriceLine(pos.tpLine);
      pos.tpLine = null;
    }
  }
  
  _renderSheet(positionId);
}

// ── Pip Labels ────────────────────────────────────────────────────
function _refreshPipLabels(positionId) {
  const pos = activePositions[positionId];
  const slEl = document.getElementById('sl-pips-' + positionId);
  const tpEl = document.getElementById('tp-pips-' + positionId);
  
  if (slEl) {
    const slPips = Math.abs(pos.slPrice - pos.entryPrice) / pip;
    slEl.textContent = slPips.toFixed(1) + ' pips';
  }
  
  if (tpEl) {
    const tpPips = Math.abs(pos.tpPrice - pos.entryPrice) / pip;
    tpEl.textContent = tpPips.toFixed(1) + ' pips';
  }
}

// ── Steppers ──────────────────────────────────────────────────────
function adjustSL(positionId, dir) {
  const pos = activePositions[positionId];
  if (!pos.slEnabled) return;
  
  pos.slPrice = parseFloat((pos.slPrice + dir * pip).toFixed(dotPosition + 1));
  
  const inp = document.getElementById('sl-input-' + positionId);
  if (inp) inp.value = pos.slPrice.toFixed(dotPosition);
  
  _redrawSLLine(positionId);
  _refreshPipLabels(positionId);
}

function adjustTP(positionId, dir) {
  const pos = activePositions[positionId];
  if (!pos.tpEnabled) return;
  
  pos.tpPrice = parseFloat((pos.tpPrice + dir * pip).toFixed(dotPosition + 1));
  
  const inp = document.getElementById('tp-input-' + positionId);
  if (inp) inp.value = pos.tpPrice.toFixed(dotPosition);
  
  _redrawTPLine(positionId);
  _refreshPipLabels(positionId);
}

function onSLInputChange(positionId, value) {
  const v = parseFloat(value);
  if (isNaN(v)) return;
  
  activePositions[positionId].slPrice = v;
  _redrawSLLine(positionId);
  _refreshPipLabels(positionId);
}

function onTPInputChange(positionId, value) {
  const v = parseFloat(value);
  if (isNaN(v)) return;
  
  activePositions[positionId].tpPrice = v;
  _redrawTPLine(positionId);
  _refreshPipLabels(positionId);
}

// ── Redraw Helpers ────────────────────────────────────────────────
function _redrawSLLine(positionId) {
  const pos = activePositions[positionId];
  if (!pos.slLine) return;
  
  candlestickSeries.removePriceLine(pos.slLine);
  pos.slLine = candlestickSeries.createPriceLine({
    price: pos.slPrice,
    color: '#FF5252',
    lineWidth: 2,
    lineStyle: LightweightCharts.LineStyle.Dashed,
    axisLabelVisible: true,
    title: 'SL',
  });
}

function _redrawTPLine(positionId) {
  const pos = activePositions[positionId];
  if (!pos.tpLine) return;
  
  candlestickSeries.removePriceLine(pos.tpLine);
  pos.tpLine = candlestickSeries.createPriceLine({
    price: pos.tpPrice,
    color: '#4CAF50',
    lineWidth: 2,
    lineStyle: LightweightCharts.LineStyle.Dashed,
    axisLabelVisible: true,
    title: 'TP',
  });
}

// ── Confirm → Flutter ─────────────────────────────────────────────
function confirmSlTp(positionId) {
  const pos = activePositions[positionId];
  
  const payload = JSON.stringify({
    positionId: positionId,
    sl: pos.slEnabled ? parseFloat(pos.slPrice.toFixed(dotPosition)) : null,
    tp: pos.tpEnabled ? parseFloat(pos.tpPrice.toFixed(dotPosition)) : null,
  });
  
  if (window.FlutterChannel) {
    window.FlutterChannel.postMessage('position_sl_tp:' + payload);
  }
  
  const btn = document.getElementById('confirm-btn-' + positionId);
  if (btn) {
    btn.textContent = '✓ Confirmed!';
    btn.style.background = '#388E3C';
    btn.disabled = true;
  }
  
  setTimeout(function() {
    closeBottomSheet();
  }, 700);
}
''';
}