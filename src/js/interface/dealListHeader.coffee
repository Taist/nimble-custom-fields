module.exports = () -> '
<table class="header" aria-hidden="true" style="display: none;">
  <colgroup>
    <col>
  </colgroup>
  <tbody>
    <tr>
      <td class="headerTD c0 subject" sorting_param="subject">Deal name</td>
      <td class="headerTD c1 related_primary" sorting_param="related_primary">Company or Person</td>
      <td class="headerTD c2 amount" sorting_param="amount">Amount</td>
      <td class="headerTD c3 stage" sorting_param="stage">Stage</td>
      <td class="headerTD c4 probability" sorting_param="probability">Probability</td>
      <td class="headerTD c5 expected_close sort" sorting_param="expected_close">Expected<span class="asc">&nbsp; </span>
      </td>
      <td class="headerTD c6 age" sorting_param="age">Age (days)</td>
    </tr>
  </tbody>
</table>
'
