module.exports = () -> '
<table class="groupHeader">
  <colgroup>
    <col>
  </colgroup>
  <tbody>
    <tr class="total">
      <td class="c0"><a class="btnExpand plus">' + @props.name + '</a>
      </td>
      <td class="c1"> </td>
      <td class="c2">$ ' + @props.amount.full + '</td>
      <td class="c3"> </td>
      <td class="c4"> </td>
      <td class="c5"> </td>
      <td class="c6"> </td>
    </tr>
    <tr class="weightedAmount">
      <td class="c0">
        <div class="gwt-HTML"></div>
      </td>
      <td class="c1">Weighted:</td>
      <td class="c2">$ ' + @props.amount.weighted + '</td>
      <td class="c3"> </td>
      <td class="c4"> </td>
      <td class="c5"> </td>
      <td class="c6"> </td>
    </tr>
  </tbody>
</table>
'
