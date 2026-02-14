/// JavaScript functions for position line management
class PositionJsFunctions {
  static const String functions = '''
// ── Position Line Drawing ─────────────────────────────────────────
function drawPositionLines(positions) {
  positions.forEach(function(pos) {
    const isBuy = pos.side === 2;
    
    const entryLine = candlestickSeries.createPriceLine({
      price: pos.price,
      color: pos.color,
      lineWidth: 2,
      lineStyle: LightweightCharts.LineStyle.Solid,
      axisLabelVisible: true,
      title: pos.label,
    });
    
    const defaultDist = DEFAULT_PIPS * pip;
    const slPrice = (pos.sl != null && pos.sl !== 0)
      ? pos.sl
      : (isBuy ? pos.price - defaultDist : pos.price + defaultDist);
    
    const tpPrice = (pos.tp != null && pos.tp !== 0)
      ? pos.tp
      : (isBuy ? pos.price + defaultDist : pos.price - defaultDist);

    activePositions[pos.positionId] = {
      entryLine: entryLine,
      slLine: null,
      tpLine: null,
      slPrice: slPrice,
      tpPrice: tpPrice,
      slEnabled: false,
      tpEnabled: false,
      entryPrice: pos.price,
      color: pos.color,
      isBuy: isBuy,
      positionId: pos.positionId,
      label: pos.label,
      qty: pos.qty || 1,
    };
    
    lastTapTime[pos.positionId] = 0;
  });
}

// ── Pointer Event Handlers ────────────────────────────────────────
function setupInteractionListeners() {
  const chartEl = document.getElementById('chart');

  chartEl.addEventListener('click', function(e) {
    handleTap(e.clientX, e.clientY);
  });

  chartEl.addEventListener('touchend', function(e) {
    if (e.changedTouches.length > 0) {
      const t = e.changedTouches[0];
      handleTap(t.clientX, t.clientY);
    }
  });
}

function handleTap(clientX, clientY) {
  const entryId = _findEntryTarget(clientY);
  
  if (entryId !== null) {
    const now = Date.now();
    
    if (now - (lastTapTime[entryId] || 0) < DOUBLE_TAP_MS) {
      lastTapTime[entryId] = 0;
      
      // Show ripple animation
      const r = document.createElement('div');
      r.className = 'tap-ripple';
      r.style.left = clientX + 'px';
      r.style.top = clientY + 'px';
      document.body.appendChild(r);
      setTimeout(function() { r.remove(); }, 450);
      
      openBottomSheet(entryId);
    } else {
      lastTapTime[entryId] = now;
    }
  }
}

function _findEntryTarget(clientY) {
  for (const posId in activePositions) {
    const pos = activePositions[posId];
    const lineY = priceToY(pos.entryPrice);
    
    if (lineY !== null && Math.abs(clientY - lineY) <= 18) {
      return parseInt(posId);
    }
  }
  return null;
}

function priceToY(price) {
  const coord = candlestickSeries.priceToCoordinate(price);
  if (coord === null) return null;
  
  const rect = document.getElementById('chart').getBoundingClientRect();
  return rect.top + coord;
}
''';
}