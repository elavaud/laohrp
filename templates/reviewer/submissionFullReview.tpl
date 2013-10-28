{**
 * submissionForFullReview.tpl
 * $Id$
 *}
{strip}
{assign var="articleId" value=$submission->getArticleId()}
{translate|assign:"pageTitleTranslated" key="submission.page.fullReviewA" id=$articleId}
{assign var="pageCrumbTitle" value="submission.review"}
{include file="common/header.tpl"}
{/strip}


<script type="text/javascript">

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
<tr valign="top">
	<td class="label">{translate key="article.journalSection"} / ຄະນະກຳມະການຈັນຍາທຳ</td>
	<td class="value">{$submission->getSectionTitle()|escape}</td>
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
					<a href="{url op="downloadFileFullReview" path=$articleId|to_array:$reviewFile->getFileId():$reviewFile->getRevision()}" class="file">{$reviewFile->getFileName()|escape}</a>
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
						<a href="{url op="downloadFileFullReview" path=$articleId|to_array:$suppFile->getFileId()}" class="file">{$suppFile->getFileName()|escape}</a><cite>&nbsp;&nbsp;({$suppFile->getType()})</cite><br />
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

<div class="separator"></div>
<div id="titleAndAbstract">
<h4>{if !$isSectionEditor}Proposal Details / {/if}ສະຫລຸບ/ສັງລວມຫຍໍ້</h4>

<table width="100%" class="data">
   <tr valign="top">
        <td class="label" width="30%">{if !$isSectionEditor}<br/>{translate key="proposal.scientificTitle"}{/if}<br/>ຫົວຂໍ້ວິທະຍາສາດ</td>
        <td class="value" width="70%"><br/>{$submission->getLocalizedTitle()}</td>
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

{if $journal->getLocalizedSetting('reviewGuidelines') != ''}
<div class="separator"></div>
<div id="reviewerGuidelines">
<h3>{translate key="reviewer.article.reviewerGuidelines"}</h3>
<p>{$journal->getLocalizedSetting('reviewGuidelines')|nl2br}</p>
</div>
{/if}

{include file="common/footer.tpl"}


