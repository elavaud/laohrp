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
        <tr><td colspan="6"><strong>ໂຄງການສະຫນີຄົ້ນຄວ້າຢູ່ໃນການທົບທວນ(ລໍຖ້າການຕັດສິນໃຈ)</strong></td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%">ລະຫັດບົດສະເຫນີ</td>
		<td width="10%">{*translate key="submissions.submit"*}ວັນທີສົ່ງໂຄງການສະຫນີຄົ້ນຄວ້າ</td>
		<td width="20%">{*translate key="article.authors"*}ຜູ້ເຮັດການຄົ້ນຄວ້າ</td>
		<td width="50%">{*translate key="article.title"*}ຫົວຂໍ້</td>
		<td width="10%" align="right">{*translate key="common.status"*}ສະຖານະ</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
<p></p>
{assign var="count" value=0}
{iterate from=submissions1 item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision() }

        {if ($status!=PROPOSAL_STATUS_DRAFT && $status!=PROPOSAL_STATUS_REVIEWED && $status != PROPOSAL_STATUS_EXEMPTED) || $decision==SUBMISSION_EDITOR_DECISION_RESUBMIT}		
			{assign var="count" value=$count+1}
            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
			<tr valign="top">
				<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
				<!-- {* <td>{$submission->getSectionAbbrev()|escape}</td> *} Commented out by MSB, Sept 25, 2011  --> 
				<!-- {* <td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td> *}  Commented out by MSB -->
   				<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
				<td><a href="{url op="submission" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html}</a></td>
				<td align="right">
					{assign var="proposalStatusKey" value=$submission->getProposalStatusKey()}
					{translate key=$proposalStatusKey}
					{if $submission->isSubmissionDue()} 
						({translate key="submissions.proposal.forContinuingReview"}) 
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
		<td colspan="6" class="nodata">{*translate key="submissions.noSubmissions"*}ບໍ່ມີຫຍັງ</td>
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
        <tr><td colspan="7"><strong>{*APPROVED PROPOSALS (Research Ongoing)*}ໂຄງການສະຫນີຄົ້ນຄວ້າ​ໄດ້ຮັບການອານຸມັດ</strong></td></tr>
	<tr><td colspan="7" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%">{*Proposal ID / *}ລະຫັດບົດສະເຫນີ</td>
		<td width="10%">{*sort_heading key="submissions.submit" sort="submitDate"*}ວັນທີສົ່ງໂຄງການສະຫນີຄົ້ນຄວ້າ</td>
		<td width="20%">{*sort_heading key="article.authors" sort="authors"*}ຜູ້ເຮັດການຄົ້ນຄວ້າ</td>
		<td width="50%">{*sort_heading key="article.title" sort="title"*}ຫົວຂໍ້</td>
		<td width="10%" align="right">{*translate key="editor.submission.dateOfApproval"*}ສະຖານະ</td>
	</tr>
	<tr><td colspan="7" class="headseparator">&nbsp;</td></tr>
<p></p>
{assign var="count" value=0}
{iterate from=submissions2 item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
     {assign var="decision" value=$submission->getMostRecentDecision() }

        {if ($status==PROPOSAL_STATUS_REVIEWED && $decision==SUBMISSION_EDITOR_DECISION_ACCEPT)}
        	{assign var="count" value=$count+1}		
			{assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
			<tr valign="top">
				<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
				<!-- {* <td>{$submission->getSectionAbbrev()|escape}</td>  *}--> <!-- Commented out by MSB -->
                <!-- {* <td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td> *} Commented out by MSB -->
   				<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->

				<td><a href="{url op="submission" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html}</a></td>
				<td>{$submission->getApprovalDate($submission->getLocale())|date_format:$dateFormatLong}</td>
			</tr>
			<tr>
				<td colspan="7" class="separator">&nbsp;</td>
			</tr>
		{/if}
{/iterate}
{if $count==0}
	<tr>
		<td colspan="6" class="nodata">{*translate key="submissions.noSubmissions"*}ບໍ່ມີຫຍັງ</td>
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
        <tr><td colspan="6"><strong>{*NOT APPROVED*}ໂຄງການສະຫນີຄົ້ນຄວ້າບໍ່ຖືກອະນຸມັດ</strong></td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%">{*Proposal ID / *}ລະຫັດບົດສະເຫນີ</td>
		<td width="10%">{*sort_heading key="submissions.submit" sort="submitDate"*}ວັນທີສົ່ງໂຄງການສະຫນີຄົ້ນຄວ້າ</td>
		<td width="20%">{*sort_heading key="article.authors" sort="authors"*}ຜູ້ເຮັດການຄົ້ນຄວ້າ</td>
		<td width="60%">{*sort_heading key="article.title" sort="title"*}ຫົວຂໍ້</td>
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
				{* <td>{$submission->getSectionAbbrev()|escape}</td> *}
				<!-- {* <td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td> *}  Commented out by MSB -->
   				<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
                <td><a href="{url op="submission" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html}</a></td>		
			</tr>
			<tr>
				<td colspan="6" class="separator">&nbsp;</td>
			</tr>
		{/if}
{/iterate}
{if $count==0}
	<tr>
		<td colspan="6" class="nodata">{*translate key="submissions.noSubmissions"*}ບໍ່ມີຫຍັງ</td>
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
        <tr><td colspan="6"><strong>{*EXEMPT FROM REVIEW*}ໄດ້ຮັບການຍົກເວັ້ນຈາກການທົບທວນ</strong></td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%">{*Proposal ID / *}ລະຫັດບົດສະເຫນີ</td>
		<td width="10%">{*sort_heading key="submissions.submit" sort="submitDate"*}ວັນທີສົ່ງໂຄງການສະຫນີຄົ້ນຄວ້າ</td>
		<td width="20%">{*sort_heading key="article.authors" sort="authors"*}ຜູ້ເຮັດການຄົ້ນຄວ້າ</td>
		<td width="60%">{*sort_heading key="article.title" sort="title"*}ຫົວຂໍ້</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
<p></p>
{assign var="count" value=0}
{iterate from=submissions4 item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision() }

        {if $status==PROPOSAL_STATUS_EXEMPTED}		
			
            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
			{assign var="count" value=$count+1}
			<tr valign="top">
				<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
				<!-- {* <td>{$submission->getSectionAbbrev()|escape}</td> *} -->
				<!-- {* <td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td> *}Commented out by MSB -->
   				<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept25, 2011 -->
                <td><a href="{url op="submission" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html}</a></td>	
			</tr>
			<tr>
				<td colspan="6" class="separator">&nbsp;</td>
			</tr>
		{/if}
{/iterate}
{if $count==0}
	<tr>
		<td colspan="6" class="nodata">{*translate key="submissions.noSubmissions"*}ບໍ່ມີຫຍັງ</td>
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

{if $submissions1->wasEmpty()}
<!--
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
-->
{else}
	<tr>
		<td colspan="4" align="left">{page_info iterator=$submissions1}</td>
		<td align="right" colspan="2">{page_links anchor="submissions" name="submissions" iterator=$submissions1 searchField=$searchField searchMatch=$searchMatch search=$search dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateFromMonth=$dateFromMonth dateToDay=$dateToDay dateToYear=$dateToYear dateToMonth=$dateToMonth dateSearchField=$dateSearchField section=$section sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}

</table>


</div>

