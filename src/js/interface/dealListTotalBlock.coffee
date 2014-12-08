module.exports = () -> '
<div class="totalBlock">
  <table class="totalTable">
    <tbody>
      <tr class="totalRow">
        <td class="total c0">' + @props.name + ' Total:</td>
        <td class="total c1"></td>
        <td class="total c2">' + @getFullAmount() + '</td>
        <td class="total c3"></td>
        <td class="total c4"></td>
        <td class="total c5"></td>
        <td class="total c6"></td>
      </tr>
      <tr class="weightedRow">
        <td class="total c0"></td>
        <td class="total c1">Weighted:</td>
        <td class="total c2 weighted">' + @getWeightedAmount() + '</td>
        <td class="total c3"></td>
        <td class="total c4"></td>
        <td class="total c5"></td>
        <td class="total c6"></td>
      </tr>
    </tbody>
  </table>
</div>
'
