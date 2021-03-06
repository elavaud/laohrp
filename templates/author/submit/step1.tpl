{**
 * step1.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Step 1 of author article submission.
 *
 * $Id$
 *}
{assign var="pageTitle" value="author.submit.step1"}
{include file="author/submit/submitHeader.tpl"}

{if $journalSettings.supportPhone}
	{assign var="howToKeyName" value="author.submit.howToSubmit"}
{else}
	{assign var="howToKeyName" value="author.submit.howToSubmitNoPhone"}
{/if}

<p title="ພົບບັນຫາ?">[?] {translate key=$howToKeyName supportName=$journalSettings.supportName supportEmail=$journalSettings.supportEmail supportPhone=$journalSettings.supportPhone}</p>

<div class="separator"></div>

<form name="submit" method="post" action="{url op="saveSubmit" path=$submitStep}" onsubmit="return checkSubmissionChecklist()">
{include file="common/formErrors.tpl"}
{if $articleId}<input type="hidden" name="articleId" value="{$articleId|escape}" />{/if}

{if count($sectionOptions) <= 1}
	<p>{translate key="author.submit.notAccepting"}</p>
{else}

{if count($sectionOptions) == 2}
	{* If there's only one section, force it and skip the section parts
	   of the interface. *}
	{foreach from=$sectionOptions item=val key=key}
		<input type="hidden" name="sectionId" value="{$key|escape}" />
	{/foreach}
{else}{* if count($sectionOptions) == 2 *}
<div id="section">

<h3>{translate key="author.submit.journalSection"} / ຄະນະກຳມະການຈັນຍາທຳ</h3>

{url|assign:"url" page="about"}
<p>{translate key="author.submit.journalSectionDescription" aboutUrl=$url}</p>

<input type="hidden" name="submissionChecklist" value="1" />

<table class="data" width="100%">
	<tr valign="top">	
		<td width="20%" title="ຄະນະກຳມະການຈັນຍາທຳ" class="label">
		[?] {fieldLabel name="sectionId" required="true" key="section.section"}</td>
		<td width="80%" class="value"><select name="sectionId" id="sectionId" size="1" class="selectMenu">{html_options options=$sectionOptions selected=$sectionId}</select></td>
	</tr>
</table>

</div>{* section *}

<div class="separator"></div>

{/if}{* if count($sectionOptions) == 2 *}

{if count($supportedSubmissionLocaleNames) == 1}
	{* There is only one supported submission locale; choose it invisibly *}
	{foreach from=$supportedSubmissionLocaleNames item=localeName key=locale}
		<input type="hidden" name="locale" value="{$locale|escape}" />
	{/foreach}
{else}
	{* There are several submission locales available; allow choice *}
	<div id="submissionLocale">

	<h3>{translate key="author.submit.submissionLocale"}</h3>
	<p>{translate key="author.submit.submissionLocaleDescription"}</p>

	<table class="data" width="100%">
		<tr valign="top">	
			<td width="20%" class="label">{fieldLabel name="locale" required="true" key="article.language"}</td>
			<td width="80%" class="value"><select name="locale" id="locale" size="1" class="selectMenu">{html_options options=$supportedSubmissionLocaleNames selected=$locale}</select></td>
		</tr>
	</table>

	<div class="separator"></div>

	</div>{* submissionLocale *}
{/if}{* count($supportedSubmissionLocaleNames) == 1 *}

<script type="text/javascript">
{literal}
<!--
function checkSubmissionChecklist() {
	var elements = document.submit.elements;
	for (var i=0; i < elements.length; i++) {
		if (elements[i].type == 'checkbox' && !elements[i].checked) {
			if (elements[i].name.match('^checklist')) {
				alert({/literal}'{translate|escape:"jsparam" key="author.submit.verifyChecklist"}'{literal});
				return false;
			} else if (elements[i].name == 'copyrightNoticeAgree') {
				alert({/literal}'{translate|escape:"jsparam" key="author.submit.copyrightNoticeAgreeRequired"}'{literal});
				return false;
			}
		}
	}
	return true;
}
// -->
{/literal}
</script>

{if $authorFees}
	{include file="author/submit/authorFees.tpl" showPayLinks=0}
	<div class="separator"></div>	
{/if}

{if $currentJournal->getLocalizedSetting('submissionChecklist')}
{foreach name=checklist from=$currentJournal->getLocalizedSetting('submissionChecklist') key=checklistId item=checklistItem}
	{if $checklistItem.content}
		{if !$notFirstChecklistItem}
			{assign var=notFirstChecklistItem value=1}
			<div id="checklist">
			<h3>{translate key="author.submit.submissionChecklist"} / ລາຍການ ຂອງການຍື່ນບົດສະເໜີຄົ້ນຄ້ວາ</h3>
			<p title="ສິ່ງທີ່ຈະຢືນຢັນວ່າ ເອກະສານບົດສະເໜີຄົ້ນຄ້ວານັ້ນ ຄົບຖ້ວນ ແລະ ພ້ອມທີ່ຈະນຳເຂົ້າສູ່ການພິຈາລະນາ ໂດຍ ຄະນະກຳມະການ ແມ່ນຕ້ອງກວດເບິ່ງຕາມລາຍການນີ້ (ຄຳເຫັນ ຕໍ່ ເລຂາຄະນະກຳມະການ ສາມາດເພີ້ມໃສ່ໄດ້ ໃນຂັ້ນຕອນ ທີ 5).">[?] {translate key="author.submit.submissionChecklistDescription"}</p>
			<table width="100%" class="data">
		{/if}
		<tr valign="top">
			<td width="5%"><input type="checkbox" id="checklist-{$smarty.foreach.checklist.iteration}" name="checklist[]" value="{$checklistId|escape}"{if $articleId || $submissionChecklist} checked="checked"{/if} /></td>
			<td width="95%"><label title="ຂ້າພະເຈົ້າຕົກລົງເຫັນດີທີ່ຈະສົ່ງບົດລາຍງນ ການຄົ້ນຄວ້າລ້າສຸດ (ທັງເປັນປື້ມບົດລາຍງານ ແລະຮູບແບບເອເລັກໂຕນິກ)" for="checklist-{$smarty.foreach.checklist.iteration}">[?] {$checklistItem.content|nl2br}</label></td>
		</tr>
	{/if}
{/foreach}
{if $notFirstChecklistItem}
	</table>
	</div>{* checklist *}
	<div class="separator"></div>
{/if}

{/if}{* if count($sectionOptions) <= 1 *}

<h3>{translate key="author.submit.documentChecklist"} / ລາຍການເອກະສານໃນການຍື່ນບົດສະເໜີຄົ້ນຄວ້າເພື່ອຂໍອະນຸມັດຈັນຍາທຳ ຈາກ ຄະນະກຳມະການ ທາງດ້ານຈັນຍາທຳ</h3>
<p title="
ອີງຕາມບົດສະເໜີຄົ້ນຄວ້າຂອງທ່ານ, ຄະນະກຳມະການແຫ່ງຊາດທາງດ້ານຈັນຍາທຳການຄົ້ນຄວ້າສາທາລະນະສຸກ ຂອງ ສ.ປ.ປ ລາວ ຮຽກຮ້ອງໃຫ້ມີເອກະສານ ດັ່ງຕໍ່ໄປນີ້ ເພື່ອເລີ່ມຕົ້ນການພິຈາລະນາບົດສະເໜີຄົ້ນຄວ້າ.
ຖ້າຫາກເອກະສານບໍ່ຄົບຖ້ວນ ຈະເຮັດໃຫ້ບົດສະເໜີການຄົ້ນຄວ້າ ບໍ່ສົມບູນ
ກະລຸນາໝາຍໃສ່ທຸກໆຫ້ອງ ຕາມລຳດັບ ເພື່ອຊີ້ໃຫ້ເຫັນວ່າ ທ່ານຮູ້ວ່າຕ້ອງມີເອກະສານ ດັ່ງຕໍ່ໄປນີ້.  
">[?] {translate key="author.submit.documentChecklistDescription"}</p>
	<table width="100%" class="data">
		<tr valign="top">
			<td width="5%"><input type="checkbox" id="checklist" name="checklist[]" value="1"{if $articleId || $submissionChecklist} checked="checked"{/if} /></td>
			<td width="95%" title="ໄຟລ໌ ຂອງບົດສະເໜີຄົ້ນຄວ້າ ພ້ອມດ້ວຍ ບົດຄັດຫຍໍ້ ທີ່ເປັນ ພາສາລາວ ແລະ ພາສາອັງກິດ">[?] {translate key="author.submit.documentChecklist1"}</label></td>
		</tr>
		<tr valign="top">
			<td width="5%"><input type="checkbox" id="checklist" name="checklist[]" value="1"{if $articleId || $submissionChecklist} checked="checked"{/if} /></td>
			<td width="95%" title="ແບບຟອມສອບຖາມ ທີ່ເປັນ ພາສາລາວ ແລະ ພາສາອັງກິດ">[?] {translate key="author.submit.documentChecklist2"}</label></td>
		</tr>
		<tr valign="top">
			<td width="5%"><input type="checkbox" id="checklist" name="checklist[]" value="1"{if $articleId || $submissionChecklist} checked="checked"{/if} /></td>
			<td width="95%" title="ໃບຍິນຍອມເຂົ້າຮ່ວມການສຶກສາ ແລະ ໃບຊີ້ແຈງໃນການຂໍການຮ່ວມມື ທີ່ເປັນພາສາລາວ ແລະ ພາສາອັງກິດ.">[?] {translate key="author.submit.documentChecklist3"}</label></td>
		</tr>
		<tr valign="top">
			<td width="5%"><input type="checkbox" id="checklist" name="checklist[]" value="1"{if $articleId || $submissionChecklist} checked="checked"{/if} /></td>
			<td width="95%" title="ຊີວະປະຫວັດຂອງຜູ້ດຳເນີນການຄົ້ນຄວ້າຫຼັກ (PI)">[?] {translate key="author.submit.documentChecklist4"}</label></td>
		</tr>
		<tr valign="top">
			<td width="5%"><input type="checkbox" id="checklist" name="checklist[]" value="1"{if $articleId || $submissionChecklist} checked="checked"{/if} /></td>
			<td width="95%" title="ໃບສະເໜີ ຂໍອະນຸມັດຈັນຍາທຳການຄົ້ນຄ້ວາ ຈາກກົມກອງ">[?] {translate key="author.submit.documentChecklist5"}</label></td>
		</tr>
	</table>
<div class="separator"></div>

        
{if $currentJournal->getLocalizedSetting('copyrightNotice') != ''}
<div id="copyrightNotice">
<h3>{translate key="about.copyrightNotice"}</h3>

<p>{$currentJournal->getLocalizedSetting('copyrightNotice')|nl2br}</p>

{if $journalSettings.copyrightNoticeAgree}
<table width="100%" class="data">
	<tr valign="top">
		<td width="5%"><input type="checkbox" name="copyrightNoticeAgree" id="copyrightNoticeAgree" value="1"{if $articleId || $copyrightNoticeAgree} checked="checked"{/if} /></td>
		<td width="95%"><label for="copyrightNoticeAgree">{translate key="author.submit.copyrightNoticeAgree"}</label></td>
	</tr>
</table>
{/if}{* $journalSettings.copyrightNoticeAgree *}
</div>{* copyrightNotice *}

<div class="separator"></div>

{/if}{* $currentJournal->getLocalizedSetting('copyrightNotice') != '' *}

<div id="privacyStatement" style="display: none">
<h3>{translate key="author.submit.privacyStatement"}</h3>
<br />
{$currentJournal->getLocalizedSetting('privacyStatement')|nl2br}
</div>

<!-- <div class="separator"></div> --> <!-- Comment out, AIM -->

<div id="commentsForEditor" style="display: none"> 
<h3>{translate key="author.submit.commentsForEditor"}</h3>

<table width="100%" class="data">
<tr valign="top">
	<td width="20%" class="label">{fieldLabel name="commentsToEditor" key="author.submit.comments"}</td>
	<td width="80%" class="value"><textarea name="commentsToEditor" id="commentsToEditor" rows="3" cols="40" class="textArea">{$commentsToEditor|escape}</textarea></td>
</tr>
</table>
</div>{* commentsForEditor *}

<!-- <div class="separator"></div> --> <!-- Comment out, AIM -->

<p><input type="submit" value="{translate key="common.saveAndContinue"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="{if $articleId}confirmAction('{url page="author"}', '{translate|escape:"jsparam" key="author.submit.cancelSubmission"}'){else}document.location.href='{url page="author" escape=false}'{/if}" /></p>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
<p><span class="formRequired">{translate key="common.laoTranslation"}</span></p>
</form>

{/if}{* If not accepting submissions *}

{include file="common/footer.tpl"}

