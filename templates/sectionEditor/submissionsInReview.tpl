{**
 * submissionsInReview.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show section editor's submissions in review.
 *
 * $Id$
 *}
<br/><br/>
<div id="submissions">
<table class="listing" width="100%">
        <tr><td colspan="6"><h3>{*ACTIVE PROPOSALS (Awaiting Decision/Revise and Resubmit)*}ໂຄງການສະຫນີຄົ້ນຄວ້າຢູ່ໃນການທົບທວນ(ລໍຖ້າການຕັດສິນໃຈ)</h3></td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">{*Proposal ID*}ລະຫັດບົດສະເຫນີ</td>
		<td width="5%">{sort_heading key="submissions.submitS" sort="submitDate"}</td>
		<td width="25%">{sort_heading key="article.authorS" sort="authors"}</td>
		<td width="35%">{sort_heading key="article.titleS" sort="title"}</td>
		<td width="25%" align="right">{sort_heading key="common.statusS" sort="status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
<p></p>
{assign var="count" value=0}
{iterate from=submissions1 item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
    {assign var="decision" value=$submission->getMostRecentDecision() }

        {if ($status!=PROPOSAL_STATUS_DRAFT && $status!=PROPOSAL_STATUS_REVIEWED && $status != PROPOSAL_STATUS_EXEMPTED) || $decision==SUBMISSION_EDITOR_DECISION_RESUBMIT}		
			
            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
			{assign var="count" value=$count+1}
			<tr valign="top">
				<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
	   			<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
           		<td><a href="{url op="submissionReview" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|escape}</a></td>
				<td align="right">
					{assign var="proposalStatusKey" value=$submission->getProposalStatusKey($status)}
					{if ($submission->getMostRecentDecision()) == SUBMISSION_EDITOR_DECISION_RESUBMIT}
						{translate key=$submission->getEditorDecisionKey()}						
					{else}
						{translate key=$proposalStatusKey}
						{assign var="reviewAssignments" value=$submission->getReviewAssignments($submission->getCurrentRound())}
						{assign var="decisionAllowed" value="false"}
						{if $reviewAssignments}
							{assign var="decisionAllowed" value="true"}
							{foreach from=$reviewAssignments item=reviewAssignment}
								{if !$reviewAssignment->getRecommendation()}
									{assign var="decisionAllowed" value="false"}
								{/if}
							{/foreach}
						{/if}
						{if ($status == PROPOSAL_STATUS_ASSIGNED) && ($decisionAllowed == "true")}
							&nbsp;(Recommendation(s) available)
						{/if}
						{if $submission->isDueForReview()==1} 
							({translate key="submissions.proposal.forContinuingReview"}) 
						{/if}
					{/if}
				</td>		
			</tr>
			<tr>
				<td colspan="6" class="separator">&nbsp;</td>
			</tr>
		{/if}
{/iterate}
{if $count==0}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" align="left">{$count} ການສົ່ງບົດ</td>
	</tr>
{/if}
</table>
<br/><br/>
<table class="listing" width="100%">
    <tr><td colspan="6"><h3>{*APPROVED PROPOSALS (Research Ongoing) !*}ໂຄງການສະຫນີຄົ້ນຄວ້າໄດ້ຮັບການອານຸມັດ</h3></td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">{*Proposal ID*}ລະຫັດບົດສະເຫນີ</td>
		<td width="5%">{sort_heading key="submissions.submitS" sort="submitDate"}</td>
		<td width="25%">{sort_heading key="article.authorS" sort="authors"}</td>
		<td width="35%">{sort_heading key="article.titleS" sort="title"}</td>
		<td width="25%" align="right">{sort_heading key="common.statusS" sort="status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
<p></p>
{assign var="count" value=0}
{iterate from=submissions2 item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision() }

        {if ($status==PROPOSAL_STATUS_REVIEWED && $decision==SUBMISSION_EDITOR_DECISION_ACCEPT) || ($status==PROPOSAL_STATUS_EXEMPTED)}		
			{assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
			{assign var="count" value=$count+1}
			<tr valign="top">
				<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
   				<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
           <td><a href="{url op="submissionReview" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|escape}</a></td>
				<td align="right">
					{assign var="displayStatus" value=$submission->getEditorDecisionKey()}
					{translate key=$displayStatus}{if $submission->isDueForReview()==1}&nbsp; ({translate key="submissions.proposal.forContinuingReview"}){/if}
				</td>		
			</tr>
			<tr>
				<td colspan="6" class="separator">&nbsp;</td>
			</tr>
		{/if}
{/iterate}
{if $count==0}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" align="left">{$count} ການສົ່ງບົດ</td>
	</tr>
{/if}
</table>

<br/><br/>
<table class="listing" width="100%">
        <tr><td colspan="6"><h3>{*NOT APPROVED*}ໂຄງການສະຫນີຄົ້ນຄວ້າບໍ່ຖືກອະນຸມັດ</h3></td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">{*Proposal ID*}ລະຫັດບົດສະເຫນ</td>
		<td width="5%">{sort_heading key="submissions.submitS" sort="submitDate"}</td>
		<td width="25%">{sort_heading key="article.authorsS" sort="authors"}</td>
		<td width="35%">{sort_heading key="article.titleS" sort="title"}</td>
		<td width="25%" align="right">{sort_heading key="common.statusS" sort="status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
<p></p>
{assign var="count" value=0}
{iterate from=submissions3 item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision() }

        {if ($status==PROPOSAL_STATUS_REVIEWED && $decision==SUBMISSION_EDITOR_DECISION_DECLINE)}		
			
            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
			{assign var="count" value=$count+1}
			<tr valign="top">
				<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
				<!-- {* <td>{$submission->getSectionAbbrev()|escape}</td> *} -->
				<!-- {* <td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td> *}  Commented out by MSB -->
   				<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
           <td><a href="{url op="submissionReview" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|escape}</a></td>
				<td align="right">
					{assign var="proposalStatusKey" value=$submission->getProposalStatusKey()}
					{if $status == PROPOSAL_STATUS_EXEMPTED}
						{translate key=$proposalStatusKey}	
					{else}
						{assign var="editorDecisionKey" value=$submission->getEditorDecisionKey()}
						{translate key=$editorDecisionKey}
					{/if}
				
				</td>		
			</tr>
			<tr>
				<td colspan="6" class="separator">&nbsp;</td>
			</tr>
		{/if}
{/iterate}
{if $count==0}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" align="left">{$count} ການສົ່ງບົດ</td>
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