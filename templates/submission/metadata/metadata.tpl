{**
 * metadata.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the submission metadata table. Non-form implementation.
 *}
{assign var="status" value=$submission->getSubmissionStatus()}
{assign var="decision" value=$submission->getMostRecentDecision()}

<div id="metadata">
{if $canEditMetadata && $isSectionEditor && $status!=PROPOSAL_STATUS_COMPLETED && $status!=PROPOSAL_STATUS_ARCHIVED && $decision!=SUBMISSION_EDITOR_DECISION_EXEMPTED && $decision!=SUBMISSION_EDITOR_DECISION_ACCEPT}
	<p><a href="{url op="viewMetadata" path=$submission->getId()}" class="action">{translate key="submission.editMetadata"}</a></p>
	{call_hook name="Templates::Submission::Metadata::Metadata::AdditionalEditItems"}
{/if}
</div>
<div id="authors">
<h4>{*translate key="article.authorsS"*}Investigator(s)</h4>
	
<table width="100%" class="data">
	{foreach name=authors from=$submission->getAuthors() item=author}
	<tr valign="top">
		<td {if $author->getPrimaryContact()}title="First investigator of the research"{else}title="Co-Investigator of the research"{/if}width="30%" class="label">{*translate key="user.name"*}{if $author->getPrimaryContact()}{if !$isSectionEditor} Investigator / {	/if}[?] ຜູ້ເຮັດການຄົ້ນຄວ້າ{else}[?] Co-Investigator{/if}</td>
		<td width="70%" class="value">
			{assign var=emailString value=$author->getFullName()|concat:" <":$author->getEmail():">"}
			{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$emailString|to_array subject=$submission->getLocalizedTitle()|strip_tags articleId=$submission->getId()}
			{$author->getFullName()|escape}<br />
			{$author->getEmail()|escape}<br />
			{if ($author->getLocalizedAffiliation()) != ""}{$author->getLocalizedAffiliation()|escape}<br/>{/if}
			{if $author->getPrimaryContact()}{$submission->getLocalizedAuthorPhoneNumber()}
			{else}
			{if ($author->getUrl()) != ""}{$author->getUrl()|escape}{/if}
			{/if}
		</td>
	</tr>

        
	{if !$smarty.foreach.authors.last}
		<tr>
			<td colspan="2" class="separator">&nbsp;</td>
		</tr>
	{/if}
	{/foreach}
</table>
</div>

<div id="titleAndAbstract">
<h4>{if !$isSectionEditor}Proposal Details / {/if}ສະຫລຸບ/ສັງລວມຫຍໍ້</h4>

<table width="100%" class="data">
   <tr valign="top">
        <td title="Scientific title of the study as it appears in the protocol submitted for funding and ethical review. This title should contain information on population, intervention, comparator and outcome(s)." class="label" width="30%">{if !$isSectionEditor}<br/>{translate key="proposal.scientificTitle"}{/if}<br/>[?] ຫົວຂໍ້ວິທະຍາສາດ</td>
        <td class="value" width="70%"><br/>{$submission->getLocalizedTitle()}</td>
    </tr>
    <tr valign="top">
        <td title="Title intended for the lay public in easily understood language." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.publicTitle"}{/if}<br/>[?] ຫົວຂໍ້ທົ່ວໄປ</td>
        <td class="value"><br/>{$submission->getLocalizedPublicTitle()}</td>
    </tr>
    <tr valign="top">
        <td title="Is the research undertaken as part of academic degree requirements?" class="label">{if !$isSectionEditor}<br/>{translate key="proposal.studentInitiatedResearch"}{/if}<br/>[?] ການຄົ້ນຄວ້າຂອງນັກສຶກສາ</td>
        <td class="value"><br/>{$submission->getLocalizedStudentInitiatedResearch()}</td>
    </tr>
    {if ($submission->getLocalizedStudentInitiatedResearch()) == "Yes"}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td title="Institution where the student is enrolled." class="value">{if !$isSectionEditor}{translate key="proposal.studentInstitution"} / {/if}[?] ອົງກອນ/ສະຖາບັນ : {$submission->getLocalizedStudentInstitution()}</td>
    </tr>
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td title="Academic degree in which the student is enrolled." class="value">{if !$isSectionEditor}{translate key="proposal.academicDegree"} / {/if}[?] ລະດັບຂັ້ນການສຶກສາ : {$submission->getLocalizedAcademicDegree()}</td>
    </tr>  
    {/if}
    <tr valign="top">
        <td title="Short description of the primary purpose of the protocol, including a brief statement of the study hypothesis. It also includes publication/s details (link/reference), if any." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.abstract"}{/if}<br/>[?] ບົດຄັດຫຍໍ້</td>
        <td class="value"><br/>{$submission->getLocalizedAbstract()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
    </tr>
    <tr valign="top">
        <td title="Significant or descriptive words." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.keywords"}{/if}<br/>[?] ຄຳສັບຫລັກ</td>
        <td class="value"><br/>{$submission->getLocalizedKeywords()}</td>
    </tr>
    <tr valign="top">
        <td title="Start date of the research." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.startDate"}{/if}<br/>[?] ວັນທີເລີ້ມ</td>
        <td class="value"><br/>{$submission->getLocalizedStartDate()}</td>
    </tr>
    <tr valign="top">
        <td title="End date of the research." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.endDate"}{/if}<br/>[?] ວັນທີສີ້ນສຸດ</td>
        <td class="value"><br/>{$submission->getLocalizedEndDate()}</td>
    </tr>
    <tr valign="top">
        <td title="Funds required for the research." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.fundsRequired"}{/if}<br/>[?] ງົບປະມານທີຄາດວ່າຈະໃຊ້ໃນການຄົ້ນຄວ້າ</td>
        <td class="value"><br/>{$submission->getLocalizedFundsRequired()} {$submission->getLocalizedSelectedCurrency()}</td>
    </tr>
    <tr valign="top">
        <td title="The individual, organization, group or other legal entity which takes responsibility for initiating, managing and/or financing a study.
The Primary Sponsor is responsible for ensuring that the research is properly registered. The Primary Sponsor may or may not be the main funder." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.primarySponsor"}{/if}<br/>[?] ຜູ້ສະຫນັບສະຫນຸນຫລັກ</td>
        <td class="value">
        	{if $submission->getLocalizedPrimarySponsor()}
        		<br/>{$submission->getLocalizedPrimarySponsorText()}
        	{/if}
        </td>
    </tr>
    {if $submission->getLocalizedSecondarySponsors()}
    <tr valign="top">
        <td title="Additional individuals, organizations or other legal persons, if any, that have agreed with the primary sponsor to take on responsibilities of sponsorship. A secondary sponsor may have agreed: 
	• to take on all the responsibilities of sponsorship jointly with the primary sponsor; or 
	• to form a group with the primary sponsor in which the responsibilities of sponsorship are allocated among the members of the group; or 
	• to act as the sponsor’s legal representative in relation to some or all of the trial sites; or 
	• to take responsibility for the accuracy of trial registration information submitted." class="label" width="20%">{if !$isSectionEditor}<br/>{translate key="proposal.secondarySponsors"}{/if}<br/>[?] ຜູ້ສະຫນັບສະຫນຸນຮ່ວມ</td>
        <td class="value">
        	{if $submission->getLocalizedSecondarySponsors()}
        		<br/>{$submission->getLocalizedSecondarySponsorText()}
        	{/if}        
        </td>
    </tr>
    {/if}
    <tr valign="top">
        <td title="Is it a nationwide research?" class="label">{if !$isSectionEditor}<br/>{translate key="proposal.nationwide"}{/if}<br/>[?] ເປັນການຄົ້ນຄວ້າລະດັບຊາດບໍ່</td>
        <td class="value"><br/>{$submission->getLocalizedNationwide()}</td>
    </tr>
    {if ($submission->getLocalizedNationwide() == "No") || ($submission->getLocalizedNationwide() == "Yes, with randomly selected provinces")}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedProposalCountryText()}</td>
    </tr>
    {/if}
    <tr valign="top">
        <td title="Is the research involving patients from different countries?"  class="label">{if !$isSectionEditor}<br/>{translate key="proposal.multiCountryResearch"}{/if}<br/>[?] ຮ່ວມກັນຫລາຍປະເທດ</td>
        <td class="value"><br/>{$submission->getLocalizedMultiCountryResearch()}</td>
    </tr>
	{if ($submission->getLocalizedMultiCountryResearch()) == "Yes"}
	<tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedMultiCountryText()}</td>
    </tr>
	{/if}
    <tr valign="top">
        <td title="Does the research involve human subject?" class="label">{if !$isSectionEditor}<br/>{translate key="proposal.withHumanSubjects"}{/if}<br/>[?] ຜູ້ເຂົ້າຮ່ວມການຄົ້ນຄວ້າແມ່ນມະນຸດບໍ່</td>
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
        <td title="Fields of research." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.researchField"}{/if}<br/>[?] ສະຖານທີ່ຄົ້ນຄວ້າ</td>
        <td class="value">
            {if $submission->getLocalizedResearchField()}
        		<br/>{$submission->getLocalizedResearchFieldText()}
        	{/if}      
        </td>
    </tr>  

     <tr valign="top">
        <td title="Data collection used for the research." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.dataCollection"}{/if}<br/>[?] ວັນເກັບກຳຂໍ້ມູນ</td>
        <td class="value"><br/>{$submission->getLocalizedDataCollection()}</td>
    </tr>   
    <tr valign="top">
        <td title="Has the proposal been reviewed by another ERC, and if yes, status of the other ERC decision" class="label">{if !$isSectionEditor}<br/>{translate key="proposal.reviewedByOtherErc"}{/if}<br/>[?] ໄດ້ທົບທວນໂດຍຄະນະກຳມະການທົບທວນດ້ານຈັນຍາທຳ</td>
        <td class="value"><br/>{$submission->getLocalizedReviewedByOtherErc()}{if $submission->getLocalizedOtherErcDecision() != 'NA'}({$submission->getLocalizedOtherErcDecision()}){/if}</td>
    </tr>
    
	<tr><td colspan="2"><br/><h4>{if !$isSectionEditor}Source(s) of monetary or material support / {/if}ການສະຫນັບສະຫນຸນແຫລ່ງທຶນແລະດ້ານອຸປະກອນເຄື່ອງໄຊ້</h4></td></tr>

    <tr valign="top">
        <td title="Any grants comming from an industry." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.industryGrant"}{/if}<br/>[?] ທືນຊ່ວຍເຫລືອລ້າຈາກພາກສ່ວນອຸດສາຫະກຳ</td>
        <td class="value"><br/>{$submission->getLocalizedIndustryGrant()}</td>
    </tr>
    {if ($submission->getLocalizedIndustryGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedNameOfIndustry()}</td>
    </tr>   
    {/if}
    <tr valign="top">
        <td title="Any grant coming from an agency (World Health Organization, Asian Development Bank...)." class="label"><br/>[?] {translate key="proposal.internationalGrant"}</td>
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
        <td title="Grant comming from the Lao PDR Ministry of Health." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.mohGrant"}{/if}<br/>[?] ທືນຊ່ວຍເຫລືອລ້າຈາກກະຊວງສາທາລະນະສຸກ</td>
        <td class="value"><br/>{$submission->getLocalizedMohGrant()}</td>
    </tr>
    <tr valign="top">
        <td title="Grant coming from the Lao PDR government (Ministry of Health excluded)." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.governmentGrant"}{/if}<br/>[?] ທືນຊ່ວຍເຫລືອລ້າຈາກລັດຖະບານລາວ(ບໍ່ແມ່ນຈາກກະຊວງສາທາລະນະສຸກ)</td>
        <td class="value"><br/>{$submission->getLocalizedGovernmentGrant()}</td>
    </tr>
    {if ($submission->getLocalizedGovernmentGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedGovernmentGrantName()}</td>
    </tr>     
    {/if}
    <tr valign="top">
        <td title="Grant coming from a university." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.universityGrant"}{/if}<br/>[?] ທືນເຮັດການຄົ້ນຄວ້າຈາກມະຫາວິທະຍາໄລ</td>
        <td class="value"><br/>{$submission->getLocalizedUniversityGrant()}</td>
    </tr>
    <tr valign="top">
        <td title="Is the research self funded?" class="label">{if !$isSectionEditor}<br/>{translate key="proposal.selfFunding"}{/if}<br/>[?] ທືນສ່ວນຕົວ</td>
        <td class="value"><br/>{$submission->getLocalizedSelfFunding()}</td>
    </tr>
    <tr valign="top">
        <td title="Any other grants." class="label">{if !$isSectionEditor}<br/>{translate key="proposal.otherGrant"}{/if}<br/>[?] ອື່ນໆ</td>
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

{if $riskAssessmentVersion}
{assign var="riskAssessment" value=$submission->getRiskAssessment()}
<h3><br/>{translate key="proposal.riskAssessment"}</h3>
<div id=riskAssessments>
	<table class="listing" width="100%">
    	<tr valign="top"><td colspan="2"><b>{translate key="proposal.researchIncludesHumanSubject"}</b></td></tr>
    	<tr valign="top" id="identityRevealedField">
    	    <td class="label" width="30%">{translate key="proposal.identityRevealed"}</td>
    	    <td class="value">{if $riskAssessment->getIdentityRevealed() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="unableToConsentField">
        	<td class="label" width="20%">{translate key="proposal.unableToConsent"}</td>
        	<td class="value">{if $riskAssessment->getUnableToConsent() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="under18Field">
    	    <td class="label" width="20%">{translate key="proposal.under18"}</td>
    	    <td class="value">{if $riskAssessment->getUnder18() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="dependentRelationshipField">
    	    <td class="label" width="20%">{translate key="proposal.dependentRelationship"}</td>
    	    <td class="value">{if $riskAssessment->getDependentRelationship() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="ethnicMinorityField">
    	    <td class="label" width="20%">{translate key="proposal.ethnicMinority"}</td>
    	    <td class="value">{if $riskAssessment->getEthnicMinority() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="impairmentField">
    	    <td class="label" width="20%">{translate key="proposal.impairment"}</td>
    	    <td class="value">{if $riskAssessment->getImpairment() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="pregnantField">
    	    <td class="label" width="20%">{translate key="proposal.pregnant"}</td>
    	    <td class="value">{if $riskAssessment->getPregnant() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.researchIncludes"}</b></td></tr>
    	<tr valign="top" id="newTreatmentField">
    	    <td class="label" width="20%">{translate key="proposal.newTreatment"}</td>
    	    <td class="value">{if $riskAssessment->getNewTreatment() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="bioSamplesField">
    	    <td class="label" width="20%">{translate key="proposal.bioSamples"}</td>
    	    <td class="value">{if $riskAssessment->getBioSamples() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="radiationField">
    	    <td class="label" width="20%">{translate key="proposal.radiation"}</td>
    	    <td class="value">{if $riskAssessment->getRadiation() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="distressField">
    	    <td class="label" width="20%">{translate key="proposal.distress"}</td>
    	    <td class="value">{if $riskAssessment->getDistress() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="inducementsField">
    	    <td class="label" width="20%">{translate key="proposal.inducements"}</td>
    	    <td class="value">{if $riskAssessment->getInducements() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="sensitiveInfoField">
    	    <td class="label" width="20%">{translate key="proposal.sensitiveInfo"}</td>
    	    <td class="value">{if $riskAssessment->getSensitiveInfo() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="deceptionField">
    	    <td class="label" width="20%">{translate key="proposal.deception"}</td>
    	    <td class="value">{if $riskAssessment->getDeception() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="reproTechnologyField">
    	    <td class="label" width="20%">{translate key="proposal.reproTechnology"}</td>
    	    <td class="value">{if $riskAssessment->getReproTechnology() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="geneticsField">
    	    <td class="label" width="20%">{translate key="proposal.genetic"}</td>
    	    <td class="value">{if $riskAssessment->getGenetic() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="stemCellField">
    	    <td class="label" width="20%">{translate key="proposal.stemCell"}</td>
    	    <td class="value">{if $riskAssessment->getStemCell() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="biosafetyField">
    	    <td class="label" width="20%">{translate key="proposal.biosafety"}</td>
    	    <td class="value">{if $riskAssessment->getBiosafety() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.researchIncludes"}</b></td></tr>
    	<tr valign="top" id="riskLevelField">
    	    <td class="label" width="20%">{translate key="proposal.riskLevel"}</td>
    	    <td class="value">
    	    {if $riskAssessment->getRiskLevel() == "1"}{translate key="proposal.riskLevelNoMore"}
    	    {elseif $riskAssessment->getRiskLevel() == "2"}{translate key="proposal.riskLevelMinore"}
    	    {elseif $riskAssessment->getRiskLevel() == "3"}{translate key="proposal.riskLevelMore"}
    	    {/if}
    	    </td>
    	</tr>
    	{if $riskAssessment->getRiskLevel() != '1'}
    	<tr valign="top" id="listRisksField">
    	    <td class="label" width="20%">{translate key="proposal.listRisks"}</td>
    	    <td class="value">{$riskAssessment->getListRisks()}</td>
    	</tr>
    	<tr valign="top" id="howRisksMinimizedField">
    	    <td class="label" width="20%">{translate key="proposal.howRisksMinimized"}</td>
    	    <td class="value">{$riskAssessment->getHowRisksMinimized()}</td>
    	</tr>
    	{/if}
    	<tr valign="top" id="riskApplyToField">
    	    <td class="label" width="20%">{translate key="proposal.riskApplyTo"}</td>
    	    <td class="value">
    	    {assign var="firstRisk" value="0"}
    	    {if $riskAssessment->getRisksToTeam() == '1'}
    	    	{if $firstRisk == '1'} & {/if}{translate key="proposal.researchTeam"}
    	    	{assign var="firstRisk" value="1"}	
    	    {/if}
    	    {if $riskAssessment->getRisksToSubjects() == '1'}
    	    	{if $firstRisk == '1'} & {/if}{translate key="proposal.researchSubjects"}
    	    	{assign var="firstRisk" value="1"}
    	    {/if}
    	    {if $riskAssessment->getRisksToCommunity() == '1'}
    	    	{if $firstRisk == '1'} & {/if}{translate key="proposal.widerCommunity"}
    	    	{assign var="firstRisk" value="1"}
    	    {/if}
    	    {if $riskAssessment->getRisksToTeam() != '1' && $riskAssessment->getRisksToSubjects() != '1' && $riskAssessment->getRisksToCommunity() != '1'}
    	    	{translate key="proposal.nobody"}
    	    {/if}
    	    </td>
    	</tr>
    	<tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.potentialBenefits"}</b></td></tr>
    	<tr valign="top" id="benefitsFromTheProjectField">
    	    <td class="label" width="20%">{translate key="proposal.benefitsFromTheProject"}</td>
    	    <td class="value">
    	    {assign var="firstBenefits" value="0"}
    	    {if $riskAssessment->getBenefitsToParticipants() == '1'}
    	    	{if $firstBenefits == '1'} & {/if}{translate key="proposal.directBenefits"}
    	    	{assign var="firstBenefits" value="1"}
    	    {/if}
    	    {if $riskAssessment->getKnowledgeOnCondition() == '1'}
    	    	{if $firstBenefits == '1'} & {/if}{translate key="proposal.participantCondition"}
    	    	{assign var="firstBenefits" value="1"}
    	    {/if}
    	    {if $riskAssessment->getKnowledgeOnDisease() == '1'}
    	    	{if $firstBenefits == '1'} & {/if}{translate key="proposal.diseaseOrCondition"}
    	    	{assign var="firstBenefits" value="1"}
    	    {/if}
    	    {if $riskAssessment->getBenefitsToParticipants() != '1' && $riskAssessment->getKnowledgeOnCondition() != '1' && $riskAssessment->getKnowledgeOnDisease() != '1'}
    	    	{translate key="proposal.noBenefits"}
    	    {/if}
    	    </td>
    	</tr>
    	<tr valign="top" id="conflictOfInterestField">
    	    <td class="label" width="20%">{translate key="proposal.conflictOfInterest"}</td>
    	    <td class="value">{if $riskAssessment->getConflictOfInterest() == "1"}{translate key="common.yes"}{elseif $riskAssessment->getConflictOfInterest() == "3"}{translate key="common.notSure"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    </table>
</div>
{/if}


