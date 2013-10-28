{**
 * submission.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show the reviewer administration page.
 *
 * FIXME: At "Notify The Editor", fix the date.
 *
 * $Id$
 *}
{strip}
{assign var="articleId" value=$submission->getArticleId()}
{assign var="reviewId" value=$reviewAssignment->getId()}
{translate|assign:"pageTitleTranslated" key="submission.page.reviewA" id=$articleId}
{assign var="pageCrumbTitle" value="submission.review"}
{include file="common/header.tpl"}
{/strip}

<script type="text/javascript">
{literal}
<!--
function confirmSubmissionCheck() {
	if (document.recommendation.recommendation.value=='') {
		alert('{/literal}{translate|escape:"javascript" key="reviewer.article.mustSelectDecision"}{literal}');
		return false;
	}
	return confirm('{/literal}{translate|escape:"javascript" key="reviewer.article.confirmDecision"}{literal}');
}

$(document).ready(function() {
	$( "#proposedDate" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', minDate: '-6 m'});
});
// -->
{/literal}


</script>
<div id="submissionToBeReviewed">
<h3>{translate key="reviewer.article.submissionToBeReviewed"} / ຍື່ນບົດສະຫນີເພື່ອໃຫ້ທົບທວນ</h3>
<table width="100%" class="data">
<tr valign="top">
	<td width="30%" class="label">Proposal ID / ລະຫັດບົດສະເຫນີ</td>
	<td width="70%" class="value">{$submission->getLocalizedWhoId()|strip_unsafe_html}</td>
</tr>
<tr valign="top">
	<td width="30%" class="label">{translate key="article.title"} / {translate key="article.titleS"}</td>
	<td width="70%" class="value">{$submission->getLocalizedTitle()|strip_unsafe_html}</td>
</tr>
{*
<tr valign="top">
	<td class="label">{translate key="article.journalSection"}</td>
	<td class="value">{$submission->getSectionTitle()|escape}</td>
</tr>
*}
<tr valign="top">
	<td class="label">{translate key="article.abstract"} / ບົດຄັດຫຍໍ້</td>
	<td class="value">{$submission->getLocalizedAbstract()|strip_unsafe_html|nl2br}</td>
</tr>

{assign var=editAssignments value=$submission->getEditAssignments()}
{foreach from=$editAssignments item=editAssignment}
	{if !$notFirstEditAssignment}
		{assign var=notFirstEditAssignment value=1}
		<tr valign="top">
			<td class="label">Secretary / ເລຂາ</td>
			<td class="value">
	{/if}
			{assign var=emailString value=$editAssignment->getEditorFullName()|concat:" <":$editAssignment->getEditorEmail():">"}
			{url|assign:"url" page="user" op="email" to=$emailString|to_array redirectUrl=$currentUrl subject=$submission->getLocalizedTitle()|strip_tags articleId=$articleId}
			{$editAssignment->getEditorFullName()|escape} {icon name="mail" url=$url}
			{if !$editAssignment->getCanEdit() || !$editAssignment->getCanReview()}
				{if $editAssignment->getCanEdit()}
					({translate key="submission.editing"} / ກວດແກ້)
				{else}
					({translate key="submission.review"} / ທົບທວນ)
				{/if}
			{/if}
			<br/>
{/foreach}
{if $notFirstEditAssignment}
		</td>
	</tr>
{/if}
 <!--
	<tr valign="top">
	       <td class="label">{translate key="submission.metadata"}</td>
	       <td class="value">
		       <a href="{url op="viewMetadata" path=$reviewId|to_array:$articleId}" class="action" target="_new">{translate key="submission.viewMetadata"}</a>
	       </td>
	</tr>-->
</table>
</div>
<div class="separator"></div>

<div id="files">
<h3>Files / ຟາຍເອກະສານ</h3>
	<table width="100%" class="data">
	{if ($confirmedStatus and not $declined) or not $journal->getSetting('restrictReviewerFileAccess')}
		<tr valign="top">
			<td width="30%" class="label">
				{translate key="submission.submissionManuscript"} / ຟາຍບົດສະເຫນີ
			</td>
			<td class="value" width="70%">
				{if $reviewFile}
				{if $submission->getDateConfirmed() or not $journal->getSetting('restrictReviewerAccessToFile')}
					<a href="{url op="downloadFile" path=$reviewId|to_array:$articleId:$reviewFile->getFileId():$reviewFile->getRevision()}" class="file">{$reviewFile->getFileName()|escape}</a>
				{else}{$reviewFile->getFileName()|escape}{/if}
				&nbsp;&nbsp;{$reviewFile->getDateModified()|date_format:$dateFormatLong}
				{else}
				{translate key="common.none"} / ບໍ່ມີຫຍັງ
				{/if}
			</td>
		</tr>
		<tr valign="top">
			<td class="label">
				{translate key="article.suppFiles"} / ຟາຍປະກອບເພີ້ມເຕີມ
			</td>
			<td class="value">
				{assign var=sawSuppFile value=0}
				{foreach from=$suppFiles item=suppFile}
					{if $suppFile->getShowReviewers() }
						{assign var=sawSuppFile value=1}
						<a href="{url op="downloadFile" path=$reviewId|to_array:$articleId:$suppFile->getFileId()}" class="file">{$suppFile->getFileName()|escape}</a><cite>&nbsp;&nbsp;({$suppFile->getType()})</cite><br />
					{/if}
				{/foreach}
				{if !$sawSuppFile}
					{translate key="common.none"}
				{/if}
			</td>
		</tr>
		{else}
		<tr><td class="nodata">{translate key="reviewer.article.restrictedFileAccess"}</td></tr>
		{/if}
	</table>
</div>

{if $submission->getDateDue()}

<div class="separator"></div>

<div id="reviewSchedule">
<h3>{translate key="reviewer.article.reviewSchedule"} / ຕາຕະລາງການທົບທວນ</h3>
<form method="post" action="{url op="reviewMeetingSchedule" }" >
<table width="100%" class="data">
<tr valign="top">
	<td class="label" width="30%">{translate key="reviewer.article.schedule.request"} / ການຮ້ອງຂໍຂອງຜູ້ກວດແກ້</td>
	<td class="value" width="70%">{if $submission->getDateNotified()}{$submission->getDateNotified()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
</tr>
<tr valign="top">
	<td class="label">{translate key="reviewer.article.schedule.response"} / ການຕອບຂອງທ່ານ</td>
	<td class="value">{if $submission->getDateConfirmed()}{$submission->getDateConfirmed()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
</tr>
<tr valign="top">
	<td class="label">{translate key="reviewer.article.schedule.submitted"} / ໄດ້ສົ່ງຟາຍເອກະສານທົບທວນ</td>
	<td class="value">{if $submission->getDateCompleted()}{$submission->getDateCompleted()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
</tr>
<tr valign="top">
	<td class="label">{translate key="reviewer.article.schedule.due"} / ກຳນົດເວລາສົ່ງການທົບທວນ</td>
	<td class="value">{if $submission->getDateDue()}{$submission->getDateDue()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
</tr>
{if $reviewAssignment->getDateCompleted() || $reviewAssignment->getDeclined() == 1 || $reviewAssignment->getCancelled() == 1}
<tr valign="top">
	<td class="label">{translate key="reviewer.article.schedule.decision"}</td>
	<td class="value">
		{if $submission->getCancelled()}
			Canceled
		{elseif $submission->getDeclined()}
			Declined
		{else}
			{assign var=recommendation value=$submission->getRecommendation()}
			{if $recommendation === '' || $recommendation === null}
				&mdash;
			{else}
				{translate key=$reviewerRecommendationOptions.$recommendation}
			{/if}
		{/if}
	</td>
</tr>
{/if}
</table>
</form>
</div>

{if !$reviewAssignment->getDateCompleted() &&  ($reviewAssignment->getDeclined() != 1) && (!$reviewAssignment->getCancelled() || ($reviewAssignment->getCancelled() == 0)) && (($submission->getMostRecentDecision() == 7) || ($submission->getMostRecentDecision() == 8))}

<div class="separator"></div>

<div id="reviewSteps">
<h3>{translate key="reviewer.article.reviewSteps"} / ຂັ້ນຕອນການທົບທວນ</h3>

{include file="common/formErrors.tpl"}

{assign var="currentStep" value=1}

<table width="100%" class="data">
<tr valign="top">
	{assign var=editAssignments value=$submission->getEditAssignments}
	{* FIXME: Should be able to assign primary editorial contact *}
	{if $editAssignments[0]}{assign var=firstEditAssignment value=$editAssignments[0]}{/if}
	<td width="3%">{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
	<td width="97%"><span class="instruct">{translate key="reviewer.article.notifyEditorA"}{if $firstEditAssignment}, {$firstEditAssignment->getEditorFullName()|escape},{/if} {translate key="reviewer.article.notifyEditorB"} <br/> ແຈ້ງກອງເລຂາວ່າທ່ານຈະທຳການທົບທວນ</span></td>
</tr>
<tr valign="top">
	<td>&nbsp;</td>
	<td>
		{translate key="submission.response"}&nbsp;&nbsp;&nbsp;&nbsp;
		{if not $confirmedStatus}
			{url|assign:"acceptUrl" op="confirmReview" reviewId=$reviewId}
			{url|assign:"declineUrl" op="confirmReview" reviewId=$reviewId declineReview=1}

			{if !$submission->getCancelled()}
				{translate key="reviewer.article.canDoReview"} {icon name="mail" url=$acceptUrl}
				&nbsp;&nbsp;&nbsp;&nbsp;
				{translate key="reviewer.article.cannotDoReview"} {icon name="mail" url=$declineUrl}
				<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ຂ້າພະເຈົ້າຈະທຳການທົບທວນ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ຂ້າພະເຈົ້າບໍ່ສາມາດທຳການທົບທວນ
			{else}
				{url|assign:"url" op="confirmReview" reviewId=$reviewId}
				{translate key="reviewer.article.canDoReview"} {icon name="mail" disabled="disabled" url=$acceptUrl}
				&nbsp;&nbsp;&nbsp;&nbsp;
				{url|assign:"url" op="confirmReview" reviewId=$reviewId declineReview=1}
				{translate key="reviewer.article.cannotDoReview"} {icon name="mail" disabled="disabled" url=$declineUrl}
				<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ຂ້າພະເຈົ້າຈະທຳການທົບທວນ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ຂ້າພະເຈົ້າບໍ່ສາມາດທຳການທົບທວນ
			{/if}
		{else}
			{if not $declined}{translate key="submission.accepted"} / ຍອມຮັບ{else}{translate key="submission.rejected"} / ຖຶກປະຕິເສດ{/if}
		{/if}
	</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
{if $journal->getLocalizedSetting('reviewGuidelines') != ''}
<tr valign="top">
        <td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
	<td><span class="instruct">{translate key="reviewer.article.consultGuidelines"}</span></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
{/if}
<tr valign="top">
	<td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
	<td><span class="instruct">{translate key="reviewer.article.downloadSubmission"}
	<br/>ກົດໃສ່ຊື່ຟາຍເພື່ອດາວໂຫລດແລະ ທົບທວນ ເອກະສານທີ່ພົວພັນກັບການສົ່ງ ໂຄງການສະເໜີຄົ້ນຄວ້ານີ້</span></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
{if $currentJournal->getSetting('requireReviewerCompetingInterests')}
	<tr valign="top">
		<td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
		<td>
			{url|assign:"competingInterestGuidelinesUrl" page="information" op="competingInterestGuidelines"}
			<span class="instruct">{translate key="reviewer.article.enterCompetingInterests" competingInterestGuidelinesUrl=$competingInterestGuidelinesUrl}</span>
			{if not $confirmedStatus or $declined or $submission->getCancelled() or $submission->getRecommendation()}<br/>
				{$reviewAssignment->getCompetingInterests()|strip_unsafe_html|nl2br}
			{else}
				<form action="{url op="saveCompetingInterests" reviewId=$reviewId}" method="post">
					<textarea {if $cannotChangeCI}disabled="disabled" {/if}name="competingInterests" class="textArea" id="competingInterests" rows="5" cols="40">{$reviewAssignment->getCompetingInterests()|escape}</textarea><br />
					<input {if $cannotChangeCI}disabled="disabled" {/if}class="button defaultButton" type="submit" value="{translate key="common.save"}" />
				</form>
			{/if}
		</td>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
{/if}{* $currentJournal->getSetting('requireReviewerCompetingInterests') *}


{if $reviewAssignment->getReviewFormId()}
	<tr valign="top">
		<td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
		<td><span class="instruct">{translate key="reviewer.article.enterReviewForm"}</span></td>
	</tr>
	<tr valign="top">
		<td>&nbsp;</td>
		<td>
			{translate key="submission.reviewForm"} 
			{if $confirmedStatus and not $declined}
				<a href="{url op="editReviewFormResponse" path=$reviewId|to_array:$reviewAssignment->getReviewFormId()}" class="icon">{icon name="comment"}</a>
			{else}
				 {icon name="comment" disabled="disabled"}
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
{else}{* $reviewAssignment->getReviewFormId() *}
	<tr valign="top">
		<td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
		<td><span class="instruct">{translate key="reviewer.article.enterReviewA"}
		<br/>ກົດທາງກ້ອງສັນຍາລັກເພື່ອປ້ອນການທົບທວນການສົ່ງເອກະສານຂອງທ່ານໃນຄັ້ງນີ້</span></td>
	</tr>
	<tr valign="top">
		<td>&nbsp;</td>
		<td>
			{translate key="submission.logType.review"} /ທົບທວນ
			{if $confirmedStatus and not $declined}
				<a href="javascript:openComments('{url op="viewPeerReviewComments" path=$articleId|to_array:$reviewId}');" class="icon">{icon name="comment"}</a>
			{else}
				 {icon name="comment" disabled="disabled"}
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
{/if}{* $reviewAssignment->getReviewFormId() *}
<tr valign="top">
	<td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
	<td><span class="instruct">{translate key="reviewer.article.uploadFile"}
	<br/>ນອກນັ້ນ,ທ່ານສາມາດອັບໂຫລດເອກະສານສຳລັບກອງເລຂາ ຄະນະກຳມະການຈັນຍາທຳເພື່ອການຄົ້ນຄວ້າແລະ/ຫລືຂໍຄຳເຫັນຂອງນັກຄົ້ນຄວ້າ
	</span></td>
</tr>
<tr valign="top">
	<td>&nbsp;</td>
	<td>
		<table class="data" width="100%">
			{foreach from=$submission->getReviewerFileRevisions() item=reviewerFile key=key}
				{assign var=uploadedFileExists value="1"}
				<tr valign="top">
				<td class="label" width="30%">
					{if $key eq "0"}
						{translate key="reviewer.article.uploadedFile"} / ອັບໂຫລດເອກະສານ
					{/if}
				</td>
				<td class="value" width="70%">
					<a href="{url op="downloadFile" path=$reviewId|to_array:$articleId:$reviewerFile->getFileId():$reviewerFile->getRevision()}" class="file">{$reviewerFile->getFileName()|escape}</a>
					{$reviewerFile->getDateModified()|date_format:$dateFormatShort}
					{if ($submission->getRecommendation() === null || $submission->getRecommendation() === '') && (!$submission->getCancelled())}
						<a class="action" href="{url op="deleteReviewerVersion" path=$reviewId|to_array:$reviewerFile->getFileId():$reviewerFile->getRevision()}">{translate key="common.deleteS"}</a>
					{/if}
				</td>
				</tr>
			{foreachelse}
				<tr valign="top">
				<td class="label" width="30%">
					{translate key="reviewer.article.uploadedFile"} / ອັບໂຫລດເອກະສານ
				</td>
				<td class="nodata">
					{translate key="common.none"} / ບໍ່ມີຫຍັງ
				</td>
				</tr>
			{/foreach}
		</table>
		{if $submission->getRecommendation() === null || $submission->getRecommendation() === ''}
			<form method="post" action="{url op="uploadReviewerVersion"}" enctype="multipart/form-data">
				<input type="hidden" name="reviewId" value="{$reviewId|escape}" />
				<input type="file" name="upload" {if not $confirmedStatus or $declined or $submission->getCancelled()}disabled="disabled"{/if} class="uploadField" />
				<input type="submit" name="submit" value="{translate key="common.uploadS"}" {if not $confirmedStatus or $declined or $submission->getCancelled()}disabled="disabled"{/if} class="button" />
			</form>

			{if $currentJournal->getSetting('showEnsuringLink')}
			<span class="instruct">
				<a class="action" href="javascript:openHelp('{get_help_id key="editorial.sectionEditorsRole.review.blindPeerReview" url="true"}')">{translate key="reviewer.article.ensuringBlindReview"}</a>
			</span>
			{/if}
		{/if}
	</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr valign="top">
	<td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
	<td><span class="instruct">{translate key="reviewer.article.selectRecommendation"}
	<br/>ເລືອກ ຂໍ້ສະເໜີແນະແລະສົງການທົບທວນເພື່ອເຂົ້າສູ່ຂະບວນການສຸດທ້າຍ. ທ່ານຕ້ອງປ້ອນການທົບທວນຫລືອັບໂຫລດຟາຍເອກະສານກ່ອນການຄັດເລືອກ ຂໍ້ສະເໜີແນະ
</span></td>
</tr>
<tr valign="top">
	<td>&nbsp;</td>
	<td>
		<table class="data" width="100%">
			<tr valign="top">
				<td class="label" width="30%">{translate key="submission.recommendation"} / ຂໍ້ສະເໜີແນະ</td>
				<td class="value" width="70%">
				{if $submission->getRecommendation() !== null && $submission->getRecommendation() !== ''}
					{assign var="recommendation" value=$submission->getRecommendation()}
					<strong>{translate key=$reviewerRecommendationOptions.$recommendation}</strong>&nbsp;&nbsp;
					{$submission->getDateCompleted()|date_format:$dateFormatShort}
				{else}
					<form name="recommendation" method="post" action="{url op="recordRecommendation"}">
					<input type="hidden" name="reviewId" value="{$reviewId|escape}" />
					<select name="recommendation" {if not $confirmedStatus or $declined or $submission->getCancelled() or (!$reviewFormResponseExists and !$reviewAssignment->getMostRecentPeerReviewComment() and !$uploadedFileExists)}disabled="disabled"{/if} class="selectMenu">
						{html_options_translate options=$reviewerRecommendationOptions selected=''}
					</select>&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="submit" name="submit" onclick="return confirmSubmissionCheck()" class="button" value="{translate key="reviewer.article.submitReview"}" {if not $confirmedStatus or $declined or $submission->getCancelled() or (!$reviewFormResponseExists and !$reviewAssignment->getMostRecentPeerReviewComment() and !$uploadedFileExists)}disabled="disabled"{/if} />
					</form>					
				{/if}
				</td>		
			</tr>
		</table>
	</td>
</tr>
</table>
</div>
{/if}
<div class="separator"></div>
<div id="titleAndAbstract">
<h4>{if !$isSectionEditor}Proposal Details / {/if}ສະຫລຸບ/ສັງລວມຫຍໍ້</h4>

<table width="100%" class="data">
   <tr valign="top">
        <td class="label" width="20%">{if !$isSectionEditor}<br/>{translate key="proposal.scientificTitle"}{/if}<br/>ຫົວຂໍ້ວິທະຍາສາດ</td>
        <td class="value" width="80%"><br/>{$submission->getLocalizedTitle()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.publicTitle"}{/if}<br/>ຫົວຂໍ້ທົ່ວໄປ</td>
        <td class="value"><br/>{$submission->getLocalizedPublicTitle()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.studentInitiatedResearch"}{/if}<br/>ການຄົ້ນຄວ້າຂອງນັກສຶກສາ</td>
        <td class="value"><br/>{$submission->getLocalizedStudentInitiatedResearch()}</td>
    </tr>
    {if ($submission->getLocalizedStudentInitiatedResearch()) == "Yes"}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{if !$isSectionEditor}{translate key="proposal.studentInstitution"} / {/if}ອົງກອນ/ສະຖາບັນ {$submission->getLocalizedStudentInstitution()}</td>
    </tr>
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{if !$isSectionEditor}{translate key="proposal.academicDegree"} / {/if}ລະດັບຂັ້ນການສຶກສາ {$submission->getLocalizedAcademicDegree()}</td>
    </tr>  
    {/if}
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.abstract"}{/if}<br/>ບົດຄັດຫຍໍ້</td>
        <td class="value"><br/>{$submission->getLocalizedAbstract()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
    </tr>
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.keywords"}{/if}<br/>ຄຳສັບຫລັກ</td>
        <td class="value"><br/>{$submission->getLocalizedKeywords()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.startDate"}{/if}<br/>ວັນທີເລີ້ມ</td>
        <td class="value"><br/>{$submission->getLocalizedStartDate()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.endDate"}{/if}<br/>ວັນທີສີ້ນສຸດ</td>
        <td class="value"><br/>{$submission->getLocalizedEndDate()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.fundsRequired"}{/if}<br/>ງົບປະມານທີຄາດວ່າຈະໃຊ້ໃນການຄົ້ນຄວ້າ</td>
        <td class="value"><br/>{$submission->getLocalizedFundsRequired()} {$submission->getLocalizedSelectedCurrency()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.primarySponsor"}{/if}<br/>ຜູ້ສະຫນັບສະຫນຸນຫລັກ</td>
        <td class="value">
        	{if $submission->getLocalizedPrimarySponsor()}
        		<br/>{$submission->getLocalizedPrimarySponsorText()}
        	{/if}
        </td>
    </tr>
    {if $submission->getLocalizedSecondarySponsors()}
    <tr valign="top">
        <td class="label" width="20%">{if !$isSectionEditor}<br/>{translate key="proposal.secondarySponsors"}{/if}<br/>ຜູ້ສະຫນັບສະຫນຸນຮ່ວມ</td>
        <td class="value">
        	{if $submission->getLocalizedSecondarySponsors()}
        		<br/>{$submission->getLocalizedSecondarySponsorText()}
        	{/if}        
        </td>
    </tr>
    {/if}
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.nationwide"}{/if}<br/>ເປັນການຄົ້ນຄວ້າລະດັບຊາດບໍ່</td>
        <td class="value"><br/>{$submission->getLocalizedNationwide()}</td>
    </tr>
    {if ($submission->getLocalizedNationwide() == "No") || ($submission->getLocalizedNationwide() == "Yes, with randomly selected provinces")}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedProposalCountryText()}</td>
    </tr>
    {/if}
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.multiCountryResearch"}{/if}<br/>ຮ່ວມກັນຫລາຍປະເທດ</td>
        <td class="value"><br/>{$submission->getLocalizedMultiCountryResearch()}</td>
    </tr>
	{if ($submission->getLocalizedMultiCountryResearch()) == "Yes"}
	<tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedMultiCountryText()}</td>
    </tr>
	{/if}
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.withHumanSubjects"}{/if}<br/>ຜູ້ເຂົ້າຮ່ວມການຄົ້ນຄວ້າແມ່ນມະນຸດບໍ່</td>
        <td class="value"><br/>{$submission->getLocalizedWithHumanSubjects()}</td>
    </tr>
    {if ($submission->getLocalizedWithHumanSubjects()) == "Yes"}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">
        	{if ($submission->getLocalizedProposalType())}
        		{$submission->getLocalizedProposalTypeText()}
        	{/if}         
        </td>
    </tr>
    {/if}
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.researchField"}{/if}<br/>ສະຖານທີ່ຄົ້ນຄວ້າ</td>
        <td class="value">
            {if $submission->getLocalizedResearchField()}
        		<br/>{$submission->getLocalizedResearchFieldText()}
        	{/if}      
        </td>
    </tr>  

     <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.dataCollection"}{/if}<br/>ວັນເກັບກຳຂໍ້ມູນ</td>
        <td class="value"><br/>{$submission->getLocalizedDataCollection()}</td>
    </tr>   
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.reviewedByOtherErc"}{/if}<br/>ໄດ້ທົບທວນໂດຍຄະນະກຳມະການທົບທວນດ້ານຈັນຍາທຳ</td>
        <td class="value"><br/>{$submission->getLocalizedReviewedByOtherErc()}{if $submission->getLocalizedOtherErcDecision() != 'NA'}({$submission->getLocalizedOtherErcDecision()}){/if}</td>
    </tr>
	<tr><td colspan="2"><br/><h4>Source(s) of monetary or material support / ການສະຫນັບສະຫນຸນແຫລ່ງທຶນແລະດ້ານອຸປະກອນເຄື່ອງໄຊ້</h4></td></tr>
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.industryGrant"}{/if}<br/>ທືນຊ່ວຍເຫລືອລ້າຈາກພາກສ່ວນອຸດສາຫະກຳ</td>
        <td class="value"><br/>{$submission->getLocalizedIndustryGrant()}</td>
    </tr>
    {if ($submission->getLocalizedIndustryGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedNameOfIndustry()}</td>
    </tr>   
    {/if}
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.internationalGrant"}</td>
        <td class="value"><br/>{$submission->getLocalizedInternationalGrant()}</td>
    </tr>
    {if ($submission->getLocalizedInternationalGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">
        	{if $submission->getLocalizedInternationalGrantName()}
        		{$submission->getLocalizedInternationalGrantNameText()} 
        	{/if}
        </td>
    </tr>     
    {/if}
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.mohGrant"}{/if}<br/>ທືນຊ່ວຍເຫລືອລ້າຈາກກະຊວງສາທາລະນະສຸກ</td>
        <td class="value"><br/>{$submission->getLocalizedMohGrant()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.governmentGrant"}{/if}<br/>ທືນຊ່ວຍເຫລືອລ້າຈາກລັດຖະບານລາວ(ບໍ່ແມ່ນຈາກກະຊວງສາທາລະນະສຸກ)</td>
        <td class="value"><br/>{$submission->getLocalizedGovernmentGrant()}</td>
    </tr>
    {if ($submission->getLocalizedGovernmentGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedGovernmentGrantName()}</td>
    </tr>     
    {/if}
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.universityGrant"}{/if}<br/>ທືນເຮັດການຄົ້ນຄວ້າຈາກມະຫາວິທະຍາໄລ</td>
        <td class="value"><br/>{$submission->getLocalizedUniversityGrant()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.selfFunding"}{/if}<br/>ທືນສ່ວນຕົວ</td>
        <td class="value"><br/>{$submission->getLocalizedSelfFunding()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{if !$isSectionEditor}<br/>{translate key="proposal.otherGrant"}{/if}<br/>ອື່ນໆ</td>
        <td class="value"><br/>{$submission->getLocalizedOtherGrant()}</td>
    </tr>
    {if ($submission->getLocalizedOtherGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedSpecifyOtherGrant()}</td>
    </tr>    
    {/if}
</table>
</div>
{/if}
{if $journal->getLocalizedSetting('reviewGuidelines') != ''}
<div class="separator"></div>
<div id="reviewerGuidelines">
<h3>{translate key="reviewer.article.reviewerGuidelines"}</h3>
<p>{$journal->getLocalizedSetting('reviewGuidelines')|nl2br}</p>
</div>
{/if}

{include file="common/footer.tpl"}


