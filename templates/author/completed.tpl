{**
 * completed.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show the details of completed submissions.
 *
 * $Id$
 *}
<div id="submissions">
<table class="listing" width="100%">
	<tr><td class="headseparator" colspan="{if $statViews}7{else}6{/if}">&nbsp;</td></tr>
	<tr valign="bottom" class="heading">
		<td title="ລະຫັດບົດສະເຫນີ" width="10%">[?] Proposal ID</td>
		<td title="ວັນທີສົ່ງໂຄງການສະຫນີຄົ້ນຄວ້າ" width="10%">[?] {*<span class="disabled">{translate key="submission.date.yyyymmdd"}</span><br />*}{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td title="ຫົວຂໍ້" width="45%">[?] {sort_heading key="article.title" sort="title"}</td>
		{if $statViews}<td width="5%">{sort_heading key="submission.views" sort="views"}</td>{/if}
		<td title="ສະຖານະ" width="25%" align="right">[?] {sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td class="headseparator" colspan="{if $statViews}7{else}6{/if}">&nbsp;</td></tr>
{iterate from=submissions1 item=submission}
	{assign var="articleId" value=$submission->getArticleId()}
        {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
	<tr valign="top">
		<td>{$whoId|escape}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
		<td><a href="{url op="submission" path=$articleId}" class="action">{$submission->getLocalizedTitle()|escape}</a></td>
		{assign var="status" value=$submission->getSubmissionStatus()}
		{if $statViews}
			<td>
				{if $status==STATUS_PUBLISHED}
					{assign var=viewCount value=0}
					{foreach from=$submission->getGalleys() item=galley}
						{assign var=thisCount value=$galley->getViews()}
						{assign var=viewCount value=$viewCount+$thisCount}
					{/foreach}
					{$viewCount|escape}
				{else}
					&mdash;
				{/if}
			</td>
		{/if}
		<td align="right">
			{* {if $status==STATUS_ARCHIVED}{translate key="submissions.archived"}
			{elseif $status==STATUS_PUBLISHED}{print_issue_id articleId="$articleId"}
			{elseif $status==STATUS_DECLINED}{translate key="submissions.declined"}
                        *}
                        {if $status==PROPOSAL_STATUS_WITHDRAWN}
                            {translate key="submissions.proposal.withdrawn"}
                        {elseif $status==PROPOSAL_STATUS_COMPLETED}
                            {translate key="submissions.proposal.completed"}<br />
                        {elseif $status==PROPOSAL_STATUS_ARCHIVED}
                            {assign var="decision" value=$submission->getMostRecentDecision()}
                            {if $decision==SUBMISSION_EDITOR_DECISION_DECLINE}
                                {translate key="submissions.proposal.decline"}
                            {elseif $decision==SUBMISSION_EDITOR_DECISION_EXEMPTED}
                                {translate key="submissions.proposal.exempted"}
                            {/if}
                         {else}
                            BUG!
			{/if}
		</td>
	</tr>

	<tr>
		<td colspan="{if $statViews}7{else}6{/if}" class="{if $submissions1->eof()}end{/if}separator">&nbsp;</td>
	</tr>
{/iterate}
{if $submissions1->wasEmpty()}
	<tr>
		<td colspan="{if $statViews}7{else}6{/if}" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="{if $statViews}7{else}6{/if}" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="{if $statViews}5{else}4{/if}" align="left">{page_info iterator=$submissions1} / ການສົ່ງບົດ</td>
		<td colspan="2" align="right">{page_links anchor="submissions" name="submissions" iterator=$submissions1 sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
</table>
{if !$submissions3->wasEmpty() || !$submissions2->wasEmpty() || !$submissions1->wasEmpty()}
<table width="100%">
	<tr>
		<td width="20%" align="left"><br/>{page_info iterator=$submissions1}</td>
		<td width="80%" align="right"><br/>{page_links anchor="submissions" name="submissions" iterator=$submissions1 searchField=$searchField searchMatch=$searchMatch search=$search dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateFromMonth=$dateFromMonth dateToDay=$dateToDay dateToYear=$dateToYear dateToMonth=$dateToMonth dateSearchField=$dateSearchField section=$section sort=$sort sortDirection=$sortDirection}</td>
	</tr>
</table>
{/if}

</div>

