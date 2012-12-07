{**
 * complete.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * The submission process has been completed; notify the author.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="author.track"}
{include file="common/header.tpl"}
{/strip}

<div id="submissionComplete">

<p style="font-size: larger;">{translate key="author.submit.submissionComplete" journalTitle=$journal->getLocalizedTitle()}</p>

<h3>Proposal Details</h3>
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
        <td title="ອົງ​ກອນ/ສະຖາບັນ" class="value">[?] {translate key="proposal.studentInstitution"} :{$article->getLocalizedStudentInstitution()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td title="ລະດັບຂັ້ນການສຶກສາ" class="value">[?] {translate key="proposal.academicDegree"} :{$article->getLocalizedAcademicDegree()}</td>
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
    {if ($article->getLocalizedNationwide() == "No") || ($article->getLocalizedNationwide() == "Yes, with randomly selected provinces")}
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
	<td width="45%">{translate key="common.originalFileName"}</td>
	<td width="25%">{translate key="common.type"}</td>
	<td width="20%" class="nowrap">{translate key="common.fileSize"}</td>
	<td width="10%" class="nowrap">{translate key="common.dateUploaded"}</td>
</tr>
<tr>
	<td colspan="5" class="headseparator">&nbsp;</td>
</tr>
{foreach from=$files item=file}
{if ($file->getType() == 'supp' || $file->getType() == 'submission/original')}
<tr valign="top">
	<td><a class="file" href="{url op="download" path=$articleId|to_array:$file->getFileId()}">{$file->getOriginalFileName()|escape}</a></td>
	<td>{if ($file->getType() == 'supp')}{translate key="article.suppFile"}{else}{translate key="author.submit.submissionFile"}{/if}</td>
	<td>{$file->getNiceFileSize()}</td>
	<td>{$file->getDateUploaded()|date_format:$dateFormatTrunc}</td>
</tr>
{/if}
{foreachelse}
<tr valign="top">
<td colspan="5" class="nodata">{translate key="author.submit.noFiles"}</td>
</tr>
{/foreach}
</table>

<div class="separator"></div>

<br />

<p>&#187; <a href="{url op="index"}">{translate key="author.track"}</a></p>
<p><span class="formRequired">{translate key="common.laoTranslation"}</span></p>

</div>

{include file="common/footer.tpl"}

