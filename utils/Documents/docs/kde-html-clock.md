# KDE Html Clock

<https://github.com/MarcinOrlowski/html-clock-plasmoid>

## Vertical Layout

```html
<div style="
  display:flex;
  flex-direction:column;
  align-items:center;
  justify-content:center;
  font-family:'JetBrainsMono Nerd Font', monospace;
  line-height:1;
">

  <!-- Time Block -->
  <div style="
    display:flex;
    flex-direction:column;
    align-items:center;
    margin-bottom:4px;
  ">
    <div style="
      font-size:18px;
      font-weight:700;
      letter-spacing:1px;
    ">
      {kk}
    </div>

    <div style="
      font-size:18px;
      font-weight:700;
      margin-top:-2px;
      letter-spacing:1px;
    ">
      {ii}
    </div>

    <div style="
      font-size:8px;
      letter-spacing:2px;
      opacity:0.6;
      margin-top:2px;
    ">
      {AA}
    </div>
  </div>

  <!-- Divider -->
  <div style="
    width:12px;
    height:1px;
    background:currentColor;
    opacity:0.2;
    margin:2px 0 4px 0;
  "></div>

  <!-- Date Block -->
  <div style="
    display:flex;
    flex-direction:column;
    align-items:center;
    font-size:9px;
    opacity:0.7;
    line-height:1.2;
    letter-spacing:0.5px;
  ">
    <div>{DD}</div>
    <div style="opacity:0.6;">{dd}</div>
    <div style="opacity:0.6;">{MM}</div>
  </div>

</div>
```

## Horizontal Layout

```html
<style type="text/css">
.two-rows-cell {
    vertical-align: middle;
    padding-right: 3px;
}

.devider {
    background-color: #66ffffff;
    padding: 0;
}

.date-cell {
    text-align: left;
    vertical-align: bottom;
    font-size: 13px;
    padding-left: 3px;
    line-height: 1.1;
}

.clock { 
    font-size: 24px; 
    font-weight: 600;
}

.seconds { 
    font-size: 20px; 
}

.dot { 
    font-size: 20px; 
}

.bright { color: #e6ffffff; }
.dark { color: #aaffffff; }
</style>

<table style="border-collapse: collapse;">
<tbody>
  <tr>
    <td class="two-rows-cell clock bright" rowspan="2">
      {hh}:{ii}<span class="seconds dot dark">.</span><span class="seconds dark">{ss}</span>
    </td>

    <td class="two-rows-cell devider" rowspan="2" width="1"></td>

    <td class="date-cell dark">{DD:U},</td>
  </tr>

  <tr>
    <td class="date-cell dark">{MM:U} {dd}</td>
  </tr>
</tbody>
</table>

```
