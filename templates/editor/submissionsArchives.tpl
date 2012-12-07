{**
 * submissionsArchives.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show section editor's submission archive.
 *
 * $Id$
 *}
<div id="submissions">
<table class="listing" width="100%">
	<tr><td class="headseparator" colspan="{if $statViews}7{else}6{/if}">&nbsp;</td></tr>
	<tr valign="bottom" class="heading">
		<td width="10%">{*Proposal ID*}ລະຫັດບົດສະເຫນີ</td>
		<td width="10%">{*sort_heading key="submissions.submit" sort="submitDate"*}ວັນທີສົ່ງໂຄງການສະຫນີຄົ້ນຄວ້າ</td>
		<td width="20%">{*sort_heading key="article.authors" sort="authors"*}ຜູ້ເຮັດການຄົ້ນຄວ້າ</td>
		<td width="50%">{*sort_heading key="article.title" sort="title"*}ຫົວຂໍ້</td>
		<td width="10%" align="right">{*sort_heading key="common.status" sort="status"*}ສະຖານະ</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>

{*foreach from=$submissions item=submission*} <!-- by AIM, Jan 21, 2012 to restore pagination -->
{iterate from=submissions item=submission}
	{assign var="articleId" value=$submission->getArticleId()}
	{assign var="articleId" value=$submission->getArticleId()}
        {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
	<tr valign="top">
		<td>{$whoId|escape}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
		<!-- {* <td>{$submission->getSectionAbbrev()|escape}</td> *} Commented out by MSB, Sep25, 2011  --> 
		<!-- {* <td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td> *} Commented out by MSB -->
	   	<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
      	<td><a href="{url op="submission" path=$articleId}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:60:"..."}</a></td>
		<td align="right">
			{assign var="status" value=$submission->getSubmissionStatus()}
			{if $status == PROPOSAL_STATUS_ARCHIVED}
				{assign var="statusKey" value=$submission->getEditorDecisionKey()}				
			{else}
				{assign var="statusKey" value=$submission->getProposalStatusKey()}			
			{/if}
			{translate key=$statusKey}
		</td>
	</tr>
	<tr>
		<td colspan="6" class="separator">&nbsp;</td>
	</tr>
{/iterate}
<!-- {*  by AIM, Jan 21 2012, to restore pagination
{foreachelse}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}ບໍ່ມີຫຍັງ</td>
	</tr>
{/foreach}
*} -->

<!-- Pagination, AIM, Jan 21 2012 -->
{if $submissions->wasEmpty()}

	<tr>
		<td colspan="6" class="nodata">{*translate key="submissions.noSubmissions"*}ບໍ່ມີຫຍັງ</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>

{else}
	<tr>
		<td colspan="4" align="left">{page_info iterator=$submissions}</td>
		<td colspan="2" align="right">{page_links anchor="submissions" name="submissions" iterator=$submissions searchField=$searchField searchMatch=$searchMatch search=$search dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateFromMonth=$dateFromMonth dateToDay=$dateToDay dateToYear=$dateToYear dateToMonth=$dateToMonth dateSearchField=$dateSearchField section=$section sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
		
</table>
</div>

