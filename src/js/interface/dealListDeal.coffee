module.exports = () -> '
<tr class="row_' + @props.id + '" groupname="Qualification">
  <td class="cell c0">
    <a href="#app/deals/view?id=' + @props.id + '" target="_blank" class="deal_subject">
      ' + @props.subject + '
    </a>
  </td>
  <td class="cell c1">' + @getContactLink() + '</td>
  <td class="cell c2">' + @getAmount() + '</td>
  <td class="cell c3">
    <span class="name">' + @props.stage.name + '</span>
    <span class="days_in_stage">
      ' + @props.days_in_stage + 'day' + (if @props.days_in_stage > 1 then 's' else '') + '
    </span>
  </td>
  <td class="cell c4">' + @props.probability + '%</td>
  <td class="cell c5">' + @expectedDate + '</td>
  <td class="cell c6">' + @props.age + '</td>
</tr>
'
