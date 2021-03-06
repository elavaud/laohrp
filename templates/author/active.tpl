{**
 * active.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show the details of active submissions.
 *
 * $Id$
 *}


<div id="submissions">
<table class="listing" width="100%">
        <tr><td colspan="6">ACTIVE PROPOSALS (Awaiting Decision) / ໂຄງການສະຫນີຄົ້ນຄວ້າຢູ່ໃນການທົບທວນ(ລໍຖ້າການຕັດສິນໃຈ)</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td title="ລະຫັດບົດສະເຫນີ" width="10%">[?] Proposal ID</td>
		<td title="ວັນທີສົ່ງໂຄງການສະຫນີຄົ້ນຄວ້າ" width="10%"><span class="disabled">{*{translate key="submission.date.yyyymmdd"}</span><br />*}[?] {sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td title="ຫົວຂໍ້" width="45%">[?] {sort_heading key="article.title" sort="title"}</td>
		<td title="ສະຖານະ" width="30%" align="right">[?] {sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>

{assign var="count" value=0}
{iterate from=submissions1 item=submission}
	{assign var="status" value=$submission->getSubmissionStatus()}
    {assign var="decision" value=$submission->getMostRecentDecision() }
        
    {if ($status!=PROPOSAL_STATUS_REVIEWED && $status != PROPOSAL_STATUS_EXEMPTED) || $decision==SUBMISSION_EDITOR_DECISION_RESUBMIT || $status==PROPOSAL_STATUS_EXTENSION }

            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}

            <tr valign="top">
                <td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
                <td>{if $submission->getDateSubmitted()}{$submission->getDateSubmitted()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
                {if $status==PROPOSAL_STATUS_DRAFT}
                    {assign var="count" value=$count+1}
                    {assign var="progress" value=$submission->getSubmissionProgress()}
                    <td><a href="{url op="submit" path=$progress articleId=$articleId}" class="action">{if $submission->getLocalizedTitle()}{$submission->getLocalizedTitle()|escape}{else}{translate key="common.untitled"}{/if}</a></td>
                {else}
                    <td><a href="{url op="submission" path=$articleId}" class="action">{if $submission->getLocalizedTitle()}{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:60:"..."}{else}{translate key="common.untitled"}{/if}</a></td>
                {/if}
                <td align="right">
                        {if $status==PROPOSAL_STATUS_DRAFT}
                            {translate key="submissions.proposal.draft"}<br /><a href="{url op="deleteSubmission" path=$articleId}" class="action" onclick="return confirm('{translate|escape:"jsparam" key="author.submissions.confirmDelete"}')">{translate key="common.delete"}</a>
                        {elseif $status==PROPOSAL_STATUS_SUBMITTED}
                            {assign var="count" value=$count+1}
                            {translate key="submissions.proposal.submitted"}<br />
                            <a {popup text="ຍົກເລີກການຄົ້ນຄວ້າ" fgcolor=#F5F5F5 bgcolor=#D86422 textcolor=#196AAA}>[?]</a><a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>

                        {elseif $status==PROPOSAL_STATUS_CHECKED}
                            {assign var="count" value=$count+1}
                            {translate key="submissions.proposal.checked"}<br />
                            <a {popup text="ຍົກເລີກການຄົ້ນຄວ້າ" fgcolor=#F5F5F5 bgcolor=#D86422 textcolor=#196AAA}>[?]</a><a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>

                        {elseif $status==PROPOSAL_STATUS_EXPEDITED}
                            {assign var="count" value=$count+1}
                            {translate key="submissions.proposal.expedited"}<br />
                            <a {popup text="ຍົກເລີກການຄົ້ນຄວ້າ" fgcolor=#F5F5F5 bgcolor=#D86422 textcolor=#196AAA}>[?]</a><a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>

                        {elseif $status==PROPOSAL_STATUS_ASSIGNED}
                            {assign var="count" value=$count+1}
                            {translate key="submissions.proposal.assigned"}<br />
                            <a {popup text="ຍົກເລີກການຄົ້ນຄວ້າ" fgcolor=#F5F5F5 bgcolor=#D86422 textcolor=#196AAA}>[?]</a><a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>

                        {elseif $status==PROPOSAL_STATUS_RETURNED}
                            {assign var="count" value=$count+1}
                            {translate key="submissions.proposal.returned"}<br />
                            <a href="{url op="resubmit" path=$articleId}" class="action">Resubmit</a><br />
                            <a {popup text="ຍົກເລີກການຄົ້ນຄວ້າ" fgcolor=#F5F5F5 bgcolor=#D86422 textcolor=#196AAA}>[?]</a><a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>
                            
                        {elseif $status==PROPOSAL_STATUS_REVIEWED}
                            {if $decision==SUBMISSION_EDITOR_DECISION_RESUBMIT}
                                {assign var="count" value=$count+1}
                                {translate key="submissions.proposal.resubmit"}<br />
                                <a href="{url op="resubmit" path=$articleId}" class="action">Resubmit</a><br />
                                <a {popup text="ຍົກເລີກການຄົ້ນຄວ້າ" fgcolor=#F5F5F5 bgcolor=#D86422 textcolor=#196AAA}>[?]</a><a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>
                                
                            {/if}
                        {/if}
                 </td>
            </tr>
            <tr>
		<td colspan="6" class="{if $submissions1->eof()}end{/if}separator">&nbsp;</td>
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
		<td colspan="6" align="left">{$count} active submission(s) / ການສົ່ງບົດ</td>
	</tr>
{/if}
</table>

<br />
<br />
<br />

<table class="listing" width="100%">
        <tr><td colspan="6">APPROVED PROPOSALS (Research Ongoing) / ໂຄງການສະຫນີຄົ້ນຄວ້າ​ໄດ້ຮັບການອານຸມັດ</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td title="ລະຫັດບົດສະເຫນີ" width="5%">[?] Proposal ID</td>
		<td title="ວັນທີສົ່ງໂຄງການສະຫນີຄົ້ນຄວ້າ" width="5%"><span class="disabled">{*{translate key="submission.date.yyyymmdd"}</span><br />*}[?] {sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td title="ຫົວຂໍ້" width="40%">[?] {sort_heading key="article.title" sort="title"}</td>
		<td title="ສະຖານະ" width="40%">[?] {sort_heading key="common.status" sort="status"}</td>
		<td width="10%">Approval Date</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>


{assign var="count" value=0}

{iterate from=submissions2 item=submission}
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision()}

        {if ($status==PROPOSAL_STATUS_REVIEWED && $decision==SUBMISSION_EDITOR_DECISION_ACCEPT) ||  ($status==PROPOSAL_STATUS_EXEMPTED)}
            {assign var="count" value=$count+1}

            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}

            <tr valign="top">
                <td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
                <td>{if $submission->getDateSubmitted()}{$submission->getDateSubmitted()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>                
                <td><a href="{url op="submission" path=$articleId}" class="action">{if $submission->getLocalizedTitle()}{$submission->getLocalizedTitle()|escape}{else}{translate key="common.untitled"}{/if}</a></td>
                <td>
                	{if ($status==PROPOSAL_STATUS_EXEMPTED)}
                		{translate key="submissions.proposal.exempted"}
                	{else}
                    	{translate key="submissions.proposal.approved"}
                    {/if}
                    {if $submission->isSubmissionDue()}
                    	&nbsp;(For Continuing Review)
                    {/if}
                    <br />
                    {if $submission->isSubmissionDue()}
						<a href="{url op="addExtensionRequest" path=$articleId}" {popup text="RTO seeking an extension of time for their research must submit a request letter via this option." fgcolor=#F5F5F5 bgcolor=#D86422 textcolor=#196AAA} class="action">&#187; Submit Extension Request</a><br />
                    {/if}
                    <a href="{url op="addProgressReport" path=$articleId}" class="action")>&#187; Submit Interim Progress Report</a><br />
                    <a href="{url op="addCompletionReport" path=$articleId}" class="action">&#187; Submit Final Report</a><br />
                    <a href="{url op="addRawDataFile" path=$articleId}" {popup text="The final data set use for final analysis (Excel, SAS, SPSS or Stata)." fgcolor=#F5F5F5 bgcolor=#D86422 textcolor=#196AAA} class="action">&#187; Upload Raw Data</a><br />
                    <a href="{url op="addOtherSuppResearchOutput" path=$articleId}"  {popup text="Journal publications, news, items or any others publications related to research." fgcolor=#F5F5F5 bgcolor=#D86422 textcolor=#196AAA} class="action">&#187; Upload Other Supplementary Research Output</a><br />

                    <a href="{url op="withdrawSubmission" path=$articleId}" class="action">&#187; {translate key="common.withdraw"}</a><br />            
                </td>
                <td align="center">
                	{if ($status==PROPOSAL_STATUS_EXEMPTED)}
                		{$submission->getDateStatusModified()|date_format:$dateFormatLong}
                	{else}{
                		$submission->getApprovalDate($submission->getLocale())|date_format:$dateFormatLong}
                	{/if}
                </td>
            </tr>
            <tr>
                    <td colspan="6" class="{if $submissions2->eof()}end{/if}separator">&nbsp;</td>
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
		<td colspan="6" align="left">{$count} submission(s) / ການສົ່ງບົດ</td>
	</tr>
{/if}
</table>

<br />
<br />
<br />

<table class="listing" width="100%">
        <tr><td colspan="6">NOT APPROVED / ບໍ່​ໄດ້​ຮັບ​ອະນຸມັດ</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td title="ລະຫັດບົດສະເຫນີ" width="15%">[?] Proposal ID</td>
		<td title="ວັນທີສົ່ງໂຄງການສະຫນີຄົ້ນຄວ້າ" width="15%"><span class="disabled">{*{translate key="submission.date.yyyymmdd"}</span><br />*}[?] {sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td title="ຫົວຂໍ້" width="45%">[?] {sort_heading key="article.title" sort="title"}</td>
		<td title="ສະຖານະ" width="25%" align="right">[?] {sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>


{assign var="count" value=0}

{iterate from=submissions3 item=submission}
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision()}

        {if ($status==PROPOSAL_STATUS_REVIEWED && $decision==SUBMISSION_EDITOR_DECISION_DECLINE)}

            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}

            <tr valign="top">
                <td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
                <td>{if $submission->getDateSubmitted()}{$submission->getDateSubmitted()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>                
                <td><a href="{url op="submission" path=$articleId}" class="action">{if $submission->getLocalizedTitle()}{$submission->getLocalizedTitle()|escape}{else}{translate key="common.untitled"}{/if}</a></td>
                <td align="right">
                    {assign var="count" value=$count+1}
                    {translate key="submissions.proposal.decline"}<br />
                    <a href="{url op="sendToArchive" path=$articleId}" class="action" onclick="return confirm('{translate|escape:"jsparam" key="author.submissions.confirmArchive"}')">{translate key="common.sendtoarchive"}</a>
                 </td>
            </tr>
            <tr>
                    <td colspan="6" class="{if $submissions3->eof()}end{/if}separator">&nbsp;</td>
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
		<td colspan="6" align="left">{$count} submission(s)  / ການສົ່ງບົດ</td>
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
