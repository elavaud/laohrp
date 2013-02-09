{**
 * step5.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Step 5 of author article submission.
 *
 * $Id$
 *}
{assign var="pageTitle" value="author.submit.step5"}
{include file="author/submit/submitHeader.tpl"}

<script type="text/javascript">
{literal}
<!--
function checkSubmissionChecklist(elements) {
	if (elements.type == 'checkbox' && !elements.checked) {
		alert({/literal}'Please agree that you will pay the proposal review fee.'{literal});
		return false;
	}
	return true;
}
// -->
{/literal}
</script>

<p>{translate key="author.submit.confirmationDescription" journalTitle=$journal->getLocalizedTitle()}</p>

<form method="post" action="{url op="saveSubmit" path=$submitStep}">
<input type="hidden" name="articleId" value="{$articleId|escape}" />
{include file="common/formErrors.tpl"}

<h3>Proposal Details</h3>
<p>{if $article->getSectionId() == 1}National Ethical Committee for Health Research{else}Ethical Committee of the University of Health Sciences{/if}</p>
<table class="listing" width="100%">
    <tr valign="top">
        <td colspan="5" class="headseparator">&nbsp;</td>
    </tr>
{foreach name=authors from=$article->getAuthors() item=author}
	<tr valign="top">
        <td title="{if $author->getPrimaryContact()}ຜູ້ເຮັດການຄົ້ນຄວ້າ{else}Co-Investigator{/if}" class="label" width="20%">[?] {if $author->getPrimaryContact()}Investigator{else}Co-Investigator{/if}</td>
        <td class="value">
			{$author->getFullName()|escape}<br />
			{$author->getEmail()|escape}<br />
			{if ($author->getLocalizedAffiliation()) != ""}{$author->getLocalizedAffiliation()|escape}<br/>{/if}
			{if $author->getPrimaryContact()}{$article->getLocalizedAuthorPhoneNumber()}
			{else}
			{if ($author->getUrl()) != ""}{$author->getUrl()|escape}{/if}
			{/if}
        </td>
    </tr>
{/foreach}
    <tr valign="top">
        <td title="ຫົວຂໍ້ວິທະຍາສາດ" class="label" width="20%">[?] {translate key="proposal.scientificTitle"}</td>
        <td class="value">{$article->getLocalizedTitle()}</td>
    </tr>
    <tr valign="top">
        <td title="ຫົວຂໍ້ທົ່ວໄປ" class="label" width="20%">[?] {translate key="proposal.publicTitle"}</td>
        <td class="value">{$article->getLocalizedPublicTitle()}</td>
    </tr>
    <tr valign="top">
        <td title="ການຄົ້ນຄວ້າຂອງນັກສຶກສາ" class="label" width="20%">[?] {translate key="proposal.studentInitiatedResearch"}</td>
        <td class="value">{$article->getLocalizedStudentInitiatedResearch()}</td>
    </tr>
    {if ($article->getLocalizedStudentInitiatedResearch()) == "Yes"}
    <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td title="ອົງ​ກອນ/ສະຖາບັນ" class="value">[?] {translate key="proposal.studentInstitution"}: {$article->getLocalizedStudentInstitution()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td title="ລະດັບຂັ້ນການສຶກສາ" class="value">[?] {translate key="proposal.academicDegree"} {$article->getLocalizedAcademicDegree()}</td>
    </tr>  
    {/if}
    <tr valign="top">
        <td title="ບົດຄັດຫຍໍ້" class="label" width="20%">[?] {translate key="proposal.abstract"}</td>
        <td class="value">{$article->getLocalizedAbstract()}</td>
    </tr>
    
    <tr valign="top">
        <td title="ຄຳສັບຫລັກ" class="label" width="20%">[?] {translate key="proposal.keywords"}</td>
        <td class="value">{$article->getLocalizedKeywords()}</td>
    </tr>
    <tr valign="top">
        <td title="ວັນທີເລີ້ມ" class="label" width="20%">[?] {translate key="proposal.startDate"}</td>
        <td class="value">{$article->getLocalizedStartDate()}</td>
    </tr>
    <tr valign="top">
        <td title="ວັນທີສີ້ນສຸດ" class="label" width="20%">[?] {translate key="proposal.endDate"}</td>
        <td class="value">{$article->getLocalizedEndDate()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.fundsRequired"}</td>
        <td class="value">{$article->getLocalizedFundsRequired()} {$article->getLocalizedSelectedCurrency()}</td>
    </tr>
    <tr valign="top">
        <td title="ຜູ້ສະຫນັບສະຫນຸນຫລັກ" class="label" width="20%">[?] {translate key="proposal.primarySponsor"}</td>
        <td class="value">
        	{if $article->getLocalizedPrimarySponsor()}
        		{$article->getLocalizedPrimarySponsorText()}
        	{/if}
        </td>
    </tr>
    {if $article->getLocalizedSecondarySponsors()}
    <tr valign="top">
        <td title="ຜູ້ສະຫນັບສະຫນຸນຮ່ວມ" class="label" width="20%">[?] {translate key="proposal.secondarySponsors"}</td>
        <td class="value">
        	{if $article->getLocalizedSecondarySponsors()}
        		{$article->getLocalizedSecondarySponsorText()}
        	{/if}        
        </td>
    </tr>
    {/if}
    <tr valign="top">
        <td title="ເປັນການຄົ້ນຄວ້າລະດັບຊາດບໍ່" class="label" width="20%">[?] {translate key="proposal.nationwide"}</td>
        <td class="value">{$article->getLocalizedNationwide()}</td>
    </tr>
    {if ($article->getLocalizedNationwide()) == "No"}
    <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getLocalizedProposalCountryText()}</td>
    </tr>
    {/if}

    <tr valign="top">
        <td title="ຮ່ວມ​ກັນຫລາຍປະເທດ" class="label" width="20%">[?] {translate key="proposal.multiCountryResearch"}</td>
        <td class="value">{$article->getLocalizedMultiCountryResearch()}</td>
    </tr>
	{if ($article->getLocalizedMultiCountryResearch()) == "Yes"}
	<tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getLocalizedMultiCountryText()}</td>
    </tr>
	{/if}
    <tr valign="top">
        <td title="ຜູ້ເຂົ້າຮ່ວມການຄົ້ນຄວ້າແມ່ນມະນຸດບໍ່" class="label" width="20%">[?] {translate key="proposal.withHumanSubjects"}</td>
        <td class="value">{$article->getLocalizedWithHumanSubjects()}</td>
    </tr>
    {if ($article->getLocalizedWithHumanSubjects()) == "Yes"}
    <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">
        	{if ($article->getLocalizedProposalType())}
        		{$article->getLocalizedProposalTypeText()}
        	{/if}      
        </td>
    </tr>
    {/if}
    
    <tr valign="top">
        <td title="ສະຖານ​ທີ່ຄົ້ນຄວ້າ" class="label" width="20%">[?] {translate key="proposal.researchField"}</td>
        <td class="value">
        	{if $article->getLocalizedResearchField()}
        		{$article->getLocalizedResearchFieldText()}
        	{/if}
        </td>
    </tr>
     <tr valign="top">
        <td title="ວັນເກັບກຳຂໍ້ມູນ" class="label" width="20%">[?] {translate key="proposal.dataCollection"}</td>
        <td class="value">{$article->getLocalizedDataCollection()}</td>
    </tr>   
    <tr valign="top">
        <td title="ໄດ້ທົບທວນໂດຍຄະນະກຳມະການທົບທວນດ້ານຈັນຍາທຳ" class="label" width="20%">[?] {translate key="proposal.reviewedByOtherErc"}</td>
        <td class="value">{$article->getLocalizedReviewedByOtherErc()}{if $article->getLocalizedOtherErcDecision() != 'NA'}({$article->getLocalizedOtherErcDecision()}){/if}</td>
    </tr>

	<tr><td colspan="2"><br/><h4>Source(s) of monetary or material support / ການສະຫນັບສະຫນຸນແຫລ່ງທຶນແລະດ້ານອຸປະກອນເຄື່ອງໄຊ້</h4></td></tr>
    
    <tr valign="top">
        <td title="ທືນຊ່ວຍເຫລືອລ້າຈາກພາກສ່ວນອຸດສາຫະກຳ" class="label" width="20%">[?] {translate key="proposal.industryGrant"}</td>
        <td class="value">{$article->getLocalizedIndustryGrant()}</td>
    </tr>
    {if ($article->getLocalizedIndustryGrant()) == "Yes"}
     <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getLocalizedNameOfIndustry()}</td>
    </tr>   
    {/if}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.internationalGrant"}</td>
        <td class="value">{$article->getLocalizedInternationalGrant()}</td>
    </tr>
    {if ($article->getLocalizedInternationalGrant()) == "Yes"}
     <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">
        	{if $article->getLocalizedInternationalGrantName()}
        		{$article->getLocalizedInternationalGrantNameText()} 
        	{/if}
        </td>
    </tr>     
    {/if}
    <tr valign="top">
        <td title="ທືນຊ່ວຍເຫລືອລ້າຈາກກະຊວງສາທາລະນະສຸກ" class="label" width="20%">[?] {translate key="proposal.mohGrant"}</td>
        <td class="value">{$article->getLocalizedMohGrant()}</td>
    </tr>
    <tr valign="top">
        <td title="ທືນຊ່ວຍເຫລືອລ້າຈາກລັດຖະບານລາວ(ບໍ່ແມ່ນຈາກກະຊວງສາທາລະນະສຸກ)" class="label" width="20%">[?] {translate key="proposal.governmentGrant"}</td>
        <td class="value">{$article->getLocalizedGovernmentGrant()}</td>
    </tr>
    {if ($article->getLocalizedGovernmentGrant()) == "Yes"}
     <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getLocalizedGovernmentGrantName()}</td>
    </tr>     
    {/if}
    <tr valign="top">
        <td title="ທືນເຮັດການຄົ້ນຄວ້າຈາກມະຫາວິທະຍາໄລ" class="label" width="20%">[?] {translate key="proposal.universityGrant"}</td>
        <td class="value">{$article->getLocalizedUniversityGrant()}</td>
    </tr>
    <tr valign="top">
        <td title="ທືນສ່ວນຕົວ" class="label" width="20%">[?] {translate key="proposal.selfFunding"}</td>
        <td class="value">{$article->getLocalizedSelfFunding()}</td>
    </tr>
    <tr valign="top">
        <td title="ອື່ນໆ" class="label" width="20%">[?] {translate key="proposal.otherGrant"}</td>
        <td class="value">{$article->getLocalizedOtherGrant()}</td>
    </tr>
    {if ($article->getLocalizedOtherGrant()) == "Yes"}
     <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getLocalizedSpecifyOtherGrant()}</td>
    </tr>    
    {/if}
</table>
<div class="separator"></div>

{* Commented out by EL on May 2 2012: Unuseful*}
{* <span style="font-size: smaller; font-style: italic;">To edit proposal details, <a href="{url op="submit" path="3" articleId=$articleId}">click here to go back Step 3.</a></span> *}

<br />
<br />

<h3>{translate key="author.submit.filesSummary"}</h3>
<table class="listing" width="100%">
<tr>
	<td colspan="5" class="headseparator">&nbsp;</td>
</tr>
<tr class="heading" valign="bottom">
	<!--td width="10%">{translate key="common.id"}</td-->
	<td width="35%">{translate key="common.originalFileName"}</td>
	<td width="25%">{translate key="common.type"}</td>
	<td width="20%" class="nowrap">{translate key="common.fileSize"}</td>
	<td width="10%" class="nowrap">{translate key="common.dateUploaded"}</td>
</tr>
<tr>
	<td colspan="5" class="headseparator">&nbsp;</td>
</tr>
{foreach from=$files item=file}
<tr valign="top">
	<!--td>{$file->getFileId()}</td-->
	<td><a class="file" href="{url op="download" path=$articleId|to_array:$file->getFileId()}">{$file->getOriginalFileName()|escape}</a></td>
	<td>{if ($file->getType() == 'supp')}{translate key="article.suppFile"}{elseif ($file->getType() == 'previous')}{translate key="author.submit.previousSubmissionFile"}{else}{translate key="author.submit.submissionFile"}{/if}</td>
	<td>{$file->getNiceFileSize()}</td>
	<td>{$file->getDateUploaded()|date_format:$dateFormatTrunc}</td>
</tr>
{foreachelse}
<tr valign="top">
<td colspan="5" class="nodata">{translate key="author.submit.noFiles"}</td>
</tr>
{/foreach}
</table>
<div class="separator"></div>

{* Commented out by EL on May 2 2012: Unuseful*}
{* <span style="font-size: smaller; font-style: italic;">To add or remove supplementary files, <a href="{url op="submit" path="4" articleId=$articleId}">click here to go back Step 4.</a></span>*}

<br />
<br />

<div id="commentsForEditor">
<h3>{translate key="author.submit.commentsForEditor"}</h3>

<table width="100%" class="data">
<tr valign="top">
	<td width="20%" class="label">{fieldLabel name="commentsToEditor" key="author.submit.comments"}</td>
	<td width="80%" class="value"><textarea name="commentsToEditor" id="commentsToEditor" rows="3" cols="40" class="textArea">{$commentsToEditor|escape}</textarea></td>
</tr>
</table>

</div>{* commentsForEditor *}

<div class="separator"></div>

{if $authorFees && $article->getLocalizedStudentInitiatedResearch() != "Yes"}
	{include file="author/submit/authorFees.tpl" showPayLinks=1}
	{if $currentJournal->getLocalizedSetting('waiverPolicy') != ''}
		{if $manualPayment}
			{*<h3>{translate key="payment.alreadyPaid"}</h3>*}
			<p>Your proposal submission is almost complete. The review process will started soon. However, the final decision will not be available till you pay the proposal review fee.</p>
			<table class="data" width="100%">
				<tr valign="top">
				<td width="5%" align="left"><input type="checkbox" id="paymentSent" name="paymentSent" value="1" {if $paymentSent}checked="checked"{/if} /></td>
				<td width="95%">{*translate key="payment.paymentSent"*}I agree to pay the proposal review fee.</td>
				</tr>
				<tr>
				<td />
				{*<td>{translate key="payment.alreadyPaidMessage"}</td>*}
				<tr>
			</table>
		{/if}
		{*
		<h3>{translate key="author.submit.requestWaiver"}</h3>
		<table class="data" width="100%">
			<tr valign="top">
				<td width="5%" align="left"><input type="checkbox" name="qualifyForWaiver" value="1" {if $qualifyForWaiver}checked="checked"{/if}/></td>
				<td width="95%">{translate key="author.submit.qualityForWaiver"}</td>
			</tr>
			<tr>
				<td />
				<td>
					<label for="commentsToEditor">{translate key="author.submit.addReasonsForWaiver"}</label><br />
					<textarea name="commentsToEditor" id="commentsToEditor" rows="3" cols="40" class="textArea">{$commentsToEditor|escape}</textarea>
				</td>
			</tr>
		</table>
		*}
	{/if}
	<p>
	Please pay the fees to:<br/><br/>
	{if $sectionId == 1}
		Secretary<br/>National Ethics Committee for Health Research<br/>Room #221<br/>National Institute of Public Health<br/>Samsenthai Road, Ban Kao Nhot, Sisattanak District,<br/>Vientiane, Lao PDR<br/>Tel: (856-21) 250670-205<br/><br/>
		Or by cheque payable to "National Institute of Public Health", the cheque can be mailed to above address or delivered in person.
	{elseif $sectionId == 2}
		Secretary<br/>Ethical Committee of the University of Health Sciences<br/>University of Health Sciences<br/>Samsenthai Road, Sisattanak District,<br/>Vientiane, Lao PDR<br/><br/>
		Cheques will soon be available. For now, please pay with cash.
	{/if}
	</p>
	<div class="separator"></div>
{/if}

{call_hook name="Templates::Author::Submit::Step5::AdditionalItems"}
<p><font color=#FF0000>Attention:<br />Before finishing the submission please make sure that all data you entered are correct. Once submitted the proposal can't be modified.<br/>
ຄຳເຕືອນ:<br/>ກ່ອນການສີ້ນສຸດການສົ່ງເອກະສານກະລຸນາກວດຄືນວ່າທຸກໆຂໍ້ມູນຂອງທ່ານໄດ້ລົງໄປຢ່າງຖືກຕ້ອງ. ບົດສະເຫນີທີ່ໄດ້ສົ່ງໄປຈະບໍ່ສາມາດປ່ຽນແປງໄດ້
</font></p>
<p><input type="submit" value="{translate key="author.submit.finishSubmission"}" class="button defaultButton" {if $authorFees && $article->getLocalizedStudentInitiatedResearch() != 'Yes'} onclick="return checkSubmissionChecklist(document.getElementById('paymentSent'))"{/if} /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="confirmAction('{url page="author"}', '{translate|escape:"jsparam" key="author.submit.cancelSubmission"}')" /></p>
<p><span class="formRequired">{translate key="common.laoTranslation"}</span></p>
</form>

{include file="common/footer.tpl"}

