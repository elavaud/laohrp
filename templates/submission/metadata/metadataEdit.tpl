{**
 * metadataEdit.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Form for changing metadata of an article (used in MetadataForm)
 *}
{strip}
{assign var="pageTitle" value="submission.editMetadata"}
{include file="common/header.tpl"}
{/strip}

{url|assign:"competingInterestGuidelinesUrl" page="information" op="competingInterestGuidelines"}

<form name="metadata" method="post" action="{url op="saveMetadata"}" enctype="multipart/form-data">
<input type="hidden" name="articleId" value="{$articleId|escape}" />
{include file="common/formErrors.tpl"}

{literal}
    <script type="text/javascript">
    <!--
    // Move author up/down
    function moveAuthor(dir, authorIndex) {
            var form = document.submit;
            form.moveAuthor.value = 1;
            form.moveAuthorDir.value = dir;
            form.moveAuthorIndex.value = authorIndex;
            form.submit();
    }
    // -->

    $(document).ready(function() {
        // Add filter of proposal types: with Human Subjects vs. without Human Subjects
        if($('input[name^="withHumanSubjects"]:checked').val() == "No" || $('input[name^="withHumanSubjects"]:checked').val() == null) {
            $('#proposalTypeField').hide();
            $('#proposalType').val("PNHS");
        } else {
            $('#proposalType option[value="PNHS"]').remove();
        }

        $('input[name^="withHumanSubjects"]').change(function(){
            var answer = $('input[name^="withHumanSubjects"]:checked').val();

            if(answer == "Yes") {
                $('#proposalTypeField').show();
                $('#proposalType option[value="PNHS"]').remove();
            } else {
                $('#proposalTypeField').hide();
                $('#proposalType').append('<option value="PNHS"></option>');
                $('#proposalType').val("PNHS");
            }
        });

        // Add filter of ERC decisions
        if($('input[name^="reviewedByOtherErc"]:checked').val() == "No" || $('input[name^="reviewedByOtherErc"]:checked').val() == null) {
            $('#otherErcDecisionField').hide();
            $('#otherErcDecision').val("NA");
        } else {
            $('#otherErcDecision option[value="NA"]').remove();
        }

        $('input[name^="reviewedByOtherErc"]').change(function(){
              var answer = $('input[name^="reviewedByOtherErc"]:checked').val();
              if(answer == "Yes") {
                  $('#otherErcDecisionField').show();
                  $('#otherErcDecision option[value="NA"]').remove();
              } else {
                  $('#otherErcDecisionField').hide();
                  $('#otherErcDecision').append('<option value="NA"></option>');
                  $('#otherErcDecision').val("NA");
              }
        });

        //Restrict end date to (start date) + 1
        $( "#startDate" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', minDate: '-1 y',
                onSelect:
                    function(dateText, inst){
                        dayAfter = new Date();
                        dayAfter = $("#startDate").datepicker("getDate");
                        dayAfter.setDate(dayAfter.getDate() + 1);
                        $("#endDate").datepicker("option","minDate", dayAfter)
                }
        });

        $( "#endDate" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', minDate: '-1 y'});

        //Start code for multi-country proposals
        $('#addAnotherCountry').click(function(){
            var proposalCountryHtml = '<tr valign="top" class="proposalCountry">' + $('#firstProposalCountry').html() + '</tr>';
            $('#firstProposalCountry').after(proposalCountryHtml);
            $('#firstProposalCountry').next().find('select').attr('selectedIndex', 0);
            $('.proposalCountry').find('.removeProposalCountry').show();
            $('#firstProposalCountry').find('.removeProposalCountry').hide();
            return false;
        });

        $('.removeProposalCountry').live('click', function(){
            $(this).closest('tr').remove();
            return false;
        });
        //End code for multi-country proposals

        //Start code for multiple proposal types
        showOrHideOtherProposalTypeField();
        $('#proposalType').change(showOrHideOtherProposalTypeField);
        //End code for multiple proposal types
    });

    function showOrHideOtherProposalTypeField() {
        var isOtherSelected = false;
        if ($('#proposalType').val() != null) {
            $.each($('#proposalType').val(), function(key, value){
                if(value == "OTHER") {
                    isOtherSelected = true;
                }
            });
        }

        if(isOtherSelected) {
            $('#otherProposalTypeField').show();
        } else {
            $('#otherProposalTypeField').hide();
        }
    }
</script>
{/literal}

{if count($formLocales) > 1}
    <div id="locales">
        <table width="100%" class="data">
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="formLocale" key="form.formLanguage"}</td>
                <td width="80%" class="value">
			{url|assign:"submitFormUrl" op="submit" path="3" articleId=$articleId escape=false}
			{* Maintain localized author info across requests *}
			{foreach from=$authors key=authorIndex item=author}
				{if $currentJournal->getSetting('requireAuthorCompetingInterests')}
					{foreach from=$author.competingInterests key="thisLocale" item="thisCompetingInterests"}
						{if $thisLocale != $formLocale}<input type="hidden" name="authors[{$authorIndex|escape}][competingInterests][{$thisLocale|escape}]" value="{$thisCompetingInterests|escape}" />{/if}
					{/foreach}
				{/if}
				{foreach from=$author.biography key="thisLocale" item="thisBiography"}
					{if $thisLocale != $formLocale}<input type="hidden" name="authors[{$authorIndex|escape}][biography][{$thisLocale|escape}]" value="{$thisBiography|escape}" />{/if}
				{/foreach}
				{foreach from=$author.affiliation key="thisLocale" item="thisAffiliation"}
					{if $thisLocale != $formLocale}<input type="hidden" name="authors[{$authorIndex|escape}][affiliation][{$thisLocale|escape}]" value="{$thisAffiliation|escape}" />{/if}
				{/foreach}
			{/foreach}
			{form_language_chooser form="submit" url=$submitFormUrl}
                    <span class="instruct">{translate key="form.formLanguage.description"}</span>
                </td>
            </tr>
        </table>
    </div>
{/if}

    <div id="authors">
        <h3>{*translate key="article.authors" *} Responsible Technical Officer</h3>

        <input type="hidden" name="deletedAuthors" value="{$deletedAuthors|escape}" />
        <input type="hidden" name="moveAuthor" value="0" />
        <input type="hidden" name="moveAuthorDir" value="" />
        <input type="hidden" name="moveAuthorIndex" value="" />

{foreach name=authors from=$authors key=authorIndex item=author}
        <input type="hidden" name="authors[{$authorIndex|escape}][authorId]" value="{$author.authorId|escape}" />
        <input type="hidden" name="authors[{$authorIndex|escape}][seq]" value="{$authorIndex+1}" />
{if $smarty.foreach.authors.total <= 1}
        <input type="hidden" name="primaryContact" value="{$authorIndex|escape}" />
{/if}

{if $authorIndex == 1}<h3>Primary Investigator(s)</h3>{/if}
        <table width="100%" class="data">
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-firstName" required="true" key="user.firstName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][firstName]" id="authors-{$authorIndex|escape}-firstName" value="{$author.firstName|escape}" size="20" maxlength="40" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-middleName" key="user.middleName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][middleName]" id="authors-{$authorIndex|escape}-middleName" value="{$author.middleName|escape}" size="20" maxlength="40" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-lastName" required="true" key="user.lastName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][lastName]" id="authors-{$authorIndex|escape}-lastName" value="{$author.lastName|escape}" size="20" maxlength="90" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-email" required="true" key="user.email"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][email]" id="authors-{$authorIndex|escape}-email" value="{$author.email|escape}" size="30" maxlength="90" /></td>
            </tr>
            <tr valign="top">
                <td class="label">{fieldLabel name="authors-$authorIndex-url" key="user.url"}</td>
                <td class="value"><input type="text" name="authors[{$authorIndex|escape}][url]" id="authors-{$authorIndex|escape}-url" value="{$author.url|escape}" size="30" maxlength="90" class="textField" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-affiliation" key="user.affiliation"}</td>
                <td width="80%" class="value">
                    <textarea name="authors[{$authorIndex|escape}][affiliation][{$formLocale|escape}]" class="textArea" id="authors-{$authorIndex|escape}-affiliation" rows="5" cols="40">{$author.affiliation[$formLocale]|escape}</textarea><br/>
                    <span class="instruct">{translate key="user.affiliation.description"}</span>
                </td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-country" key="common.country"}</td>
                <td width="80%" class="value">
                    <select name="authors[{$authorIndex|escape}][country]" id="authors-{$authorIndex|escape}-country" class="selectMenu">
                        <option value=""></option>
			{html_options options=$countries selected=$author.country}
                    </select>
                </td>
            </tr>
{if $currentJournal->getSetting('requireAuthorCompetingInterests')}
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-competingInterests" key="author.competingInterests" competingInterestGuidelinesUrl=$competingInterestGuidelinesUrl}</td>
                <td width="80%" class="value"><textarea name="authors[{$authorIndex|escape}][competingInterests][{$formLocale|escape}]" class="textArea" id="authors-{$authorIndex|escape}-competingInterests" rows="5" cols="40">{$author.competingInterests[$formLocale]|escape}</textarea></td>
            </tr>
{/if}{* requireAuthorCompetingInterests *}
            <!-- Comment Out, AIM, May 31, 2011
{*
<tr valign="top">
	<td width="20%" class="label">{fieldLabel name="authors-$authorIndex-biography" key="user.biography"}<br />{translate key="user.biography.description"}</td>
	<td width="80%" class="value"><textarea name="authors[{$authorIndex|escape}][biography][{$formLocale|escape}]" class="textArea" id="authors-{$authorIndex|escape}-biography" rows="5" cols="40">{$author.biography[$formLocale]|escape}</textarea></td>
</tr>
*}
            -->

{call_hook name="Templates::Author::Submit::Authors"}

{if $smarty.foreach.authors.total > 2}
            <!--
{*
<tr valign="top">
	<td colspan="2">
		<a href="javascript:moveAuthor('u', '{$authorIndex|escape}')" class="action">&uarr;</a>
                <a href="javascript:moveAuthor('d', '{$authorIndex|escape}')" class="action">&darr;</a>
		{translate key="author.submit.reorderInstructions"}
	</td>
</tr>
*}
            -->
            <tr valign="top">
                <td width="80%" class="value" colspan="2">
                    <div style="display:none">
                        <input type="radio" name="primaryContact" value="{$authorIndex|escape}"{if $primaryContact == $authorIndex} checked="checked"{/if} /> <label for="primaryContact">{*translate key="author.submit.selectPrincipalContact"*}</label>
                    </div>
            {if $authorIndex != 0}
                    <input type="submit" name="delAuthor[{$authorIndex|escape}]" value="{*translate key="author.submit.deleteAuthor"*}Delete Primary Investigator" class="button" />
            {else}
                    &nbsp;
            {/if}
                </td>
            </tr>
            <tr>
                <td colspan="2"><br/></td>
            </tr>
{/if}


        </table>
{foreachelse}
        <input type="hidden" name="authors[0][authorId]" value="0" />
        <input type="hidden" name="primaryContact" value="0" />
        <input type="hidden" name="authors[0][seq]" value="1" />
        <table width="100%" class="data">
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-0-firstName" required="true" key="user.firstName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[0][firstName]" id="authors-0-firstName" size="20" maxlength="40" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-0-middleName" key="user.middleName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[0][middleName]" id="authors-0-middleName" size="20" maxlength="40" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-0-lastName" required="true" key="user.lastName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[0][lastName]" id="authors-0-lastName" size="20" maxlength="90" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-0-affiliation" key="user.affiliation"}</td>
                <td width="80%" class="value">
                    <textarea name="authors[0][affiliation][{$formLocale|escape}]" class="textArea" id="authors-0-affiliation" rows="5" cols="40"></textarea><br/>
                    <span class="instruct">{translate key="user.affiliation.description"}</span>
                </td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-0-country" key="common.country"}</td>
                <td width="80%" class="value">
                    <select name="authors[0][country]" id="authors-0-country" class="selectMenu">
                        <option value=""></option>
			{html_options options=$countries}
                    </select>
                </td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-0-email" required="true" key="user.email"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[0][email]" id="authors-0-email" size="30" maxlength="90" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-0-url" required="true" key="user.url"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[0][url]" id="authors-0-url" size="30" maxlength="90" /></td>
            </tr>
{if $currentJournal->getSetting('requireAuthorCompetingInterests')}
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-0-competingInterests" key="author.competingInterests" competingInterestGuidelinesUrl=$competingInterestGuidelinesUrl}</td>
                <td width="80%" class="value"><textarea name="authors[0][competingInterests][{$formLocale|escape}]" class="textArea" id="authors-0-competingInterests" rows="5" cols="40"></textarea></td>
            </tr>
{/if}
            <!-- Comment out, AIM May 31, 2011
{*
<tr valign="top">
	<td width="20%" class="label">{fieldLabel name="authors-0-biography" key="user.biography"}<br />{translate key="user.biography.description"}</td>
	<td width="80%" class="value"><textarea name="authors[0][biography][{$formLocale|escape}]" class="textArea" id="authors-0-biography" rows="5" cols="40"></textarea></td>
</tr>
*}
            -->
        </table>
{/foreach}
        <br /><br />
        <p><input type="submit" class="button" name="addAuthor" value="{*translate key="author.submit.addAuthor"*}Add Another Primary Investigator" /></p>
    </div>
    <div class="separator"></div>

    <div id="titleAndAbstract">
        <h3>{translate key="submission.titleAndAbstract"}</h3>

        <table width="100%" class="data">


            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="title" required="true" key="proposal.title"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="title[{$formLocale|escape}]" id="title" value="{$title[$formLocale]|escape}" size="50" maxlength="255" /></td>
            </tr>

            <tr valign="top">
                <td width="20%" class="label">{if $section->getAbstractsNotRequired()==0}{fieldLabel name="abstract" key="proposal.abstract" required="true"}{else}{fieldLabel name="abstract" key="proposal.abstract"}{/if}</td>
                <td width="80%" class="value"><textarea name="abstract[{$formLocale|escape}]" id="abstract" class="textArea" rows="15" cols="50">{$abstract[$formLocale]|escape}</textarea></td>
            </tr>

            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="objectives" required="true" key="proposal.objectives"}</td>
                <td width="80%" class="value"><textarea name="objectives[{$formLocale|escape}]" id="objectives" class="textArea" rows="5" cols="50">{$objectives[$formLocale]|escape}</textarea></td>
            </tr>

            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="keywords" required="true" key="proposal.keywords"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="keywords[{$formLocale|escape}]" id="keywords" value="{$keywords[$formLocale]|escape}" size="50" maxlength="255" /></td>
            </tr>

            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="startDate" required="true" key="proposal.startDate"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="startDate[{$formLocale|escape}]" id="startDate" value="{$startDate[$formLocale]|escape}" size="20" maxlength="255" /></td>
            </tr>

            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="endDate" required="true" key="proposal.endDate"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="endDate[{$formLocale|escape}]" id="endDate" value="{$endDate[$formLocale]|escape}" size="20" maxlength="255" /></td>
            </tr>

            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="fundsRequired" required="true" key="proposal.fundsRequired"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="fundsRequired[{$formLocale|escape}]" id="fundsRequired" value="{$fundsRequired[$formLocale]|escape}" size="20" maxlength="255" /></td>
            </tr>

{* Last updated by AIM, 01.11.12 *}
<!-- Do not allow country edits
{*
{foreach from=$proposalCountry[$formLocale] key=i item=country}
            <tr valign="top" {if $i == 0}id="firstProposalCountry"{/if} class="proposalCountry">
                <td width="20%" class="label">{fieldLabel name="proposalCountry" required="true" key="proposal.proposalCountry"}</td>
                <td width="80%" class="value">
                    <select name="proposalCountry[{$formLocale|escape}][]" id="proposalCountry" class="selectMenu">
                        <option value=""></option>
		{html_options options=$proposalCountries selected=$proposalCountry[$formLocale][$i]}
                    </select>
                    <a href="" class="removeProposalCountry" {if $i == 0}style="display:none"{/if}>Remove</a>
                </td>
            </tr>
{foreachelse}
            <tr valign="top" {if $i == 0}id="firstProposalCountry"{/if} class="proposalCountry">
                <td width="20%" class="label">{fieldLabel name="proposalCountry" required="true" key="proposal.proposalCountry"}</td>
                <td width="80%" class="value">
                    <select name="proposalCountry[{$formLocale|escape}][]" id="proposalCountry" class="selectMenu">
                        <option value=""></option>
		{html_options options=$proposalCountries}
                    </select>
                    <a href="" class="removeProposalCountry" {if $i == 0}style="display:none"{/if}>Remove</a>
                </td>
            </tr>
{/foreach}
            <tr>
                <td width="20%">&nbsp;</td>
                <td><a href="#" id="addAnotherCountry">Add Another Country</a></td>
            </tr>
*}
-->
            {foreach from=$proposalCountryText[$formLocale] key=i item=country}
                <tr valign="top">
                    <td width="20%" class="label">{fieldLabel name="proposalCountry" required="true" key="proposal.proposalCountry"}</td>
                    <td width="80%" class="value">
                        {$proposalCountryText[$formLocale][$i]}
                    </td>
                </tr>
            {/foreach}

{* Last updated by AIM, 01.11.12 *}
<!-- Do not allow technical unit edits
{*
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="technicalUnit" required="true" key="proposal.technicalUnit"}</td>
                <td width="80%" class="value">
                    <select name="technicalUnit[{$formLocale|escape}]" id="technicalUnit" class="selectMenu">
                        <option value=""></option>
		{html_options options=$technicalUnits selected=$technicalUnit[$formLocale]}
                    </select>
                </td>
            </tr>
*}
-->
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="technicalUnit" required="true" key="proposal.technicalUnit"}</td>
                <td width="80%" class="value">
                    {$technicalUnitText}
                </td>
            </tr>

            <!-- Add filter of proposal types: with Human Subjects vs. without Human Subjects -->
            <!-- Added by spf, 20 Dec 2011 -->

            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="withHumanSubjects" required="true" key="proposal.withHumanSubjects"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="withHumanSubjects[{$formLocale|escape}]" id="withHumanSubjects" value="Yes" {if  $withHumanSubjects[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="withHumanSubjects[{$formLocale|escape}]" id="withHumanSubjects" value="No" {if  $withHumanSubjects[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>

            <tr valign="top" id="proposalTypeField">
                <td width="20%" class="label">{fieldLabel name="proposalType" required="false" key="proposal.proposalType"}</td>
                <td width="80%" class="value">
                    <select name="proposalType[{$formLocale|escape}][]"  multiple="multiple" size="7" id="proposalType" class="selectMenu">

                        <option value="PNHS"></option>
                        {foreach from=$proposalTypes key=id item=ptype}
                            {if $ptype.code != "PNHS"}
                                {assign var="isSelected" value=false}
                                {foreach from=$proposalType[$formLocale] key=i item=selectedTypes}
                                    {if $proposalType[$formLocale][$i] == $ptype.code}
                                        {assign var="isSelected" value=true}
                                    {/if}
                                {/foreach}
                                <option value="{$ptype.code}" {if $isSelected==true}selected="selected"{/if} >{$ptype.name}</option>
                            {/if}
                        {/foreach}
                    </select>
                </td>
            </tr>
            <tr valign="top" id="otherProposalTypeField" style="display: none;">
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                    <span style="font-style: italic;">Specify "other" proposal type</span>&nbsp;&nbsp;
                    <input type="text" name="otherProposalType" id="otherProposalType" size="20" {if $otherProposalType}value="{$otherProposalType}"{/if} />
                </td>
            </tr>

            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="submittedAsPi" required="true" key="proposal.submittedAsPi"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="submittedAsPi[{$formLocale|escape}]" id="submittedAsPi" value="Yes" {if  $submittedAsPi[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="submittedAsPi[{$formLocale|escape}]" id="submittedAsPi" value="No" {if  $submittedAsPi[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>

            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="conflictOfInterest" required="true" key="proposal.conflictOfInterest"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="conflictOfInterest[{$formLocale|escape}]" id="conflictOfInterest" value="Yes" {if  $conflictOfInterest[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="conflictOfInterest[{$formLocale|escape}]" id="conflictOfInterest" value="No" {if  $conflictOfInterest[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>

            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="reviewedByOtherErc" required="true" key="proposal.reviewedByOtherErc"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="reviewedByOtherErc[{$formLocale|escape}]" id="reviewedByOtherErc" value="Yes" {if  $reviewedByOtherErc[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="reviewedByOtherErc[{$formLocale|escape}]" id="reviewedByOtherErc" value="No" {if  $reviewedByOtherErc[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>

            <tr valign="top" id="otherErcDecisionField">
                <td width="20%" class="label">{fieldLabel name="otherErcDecision" required="false" key="proposal.otherErcDecision"}</td>
                <td width="80%" class="value">
                    <select name="otherErcDecision[{$formLocale|escape}]" id="otherErcDecision" class="selectMenu">
                        <option value="NA"></option>
                        <option value="Under Review" {if  $otherErcDecision[$formLocale] == "Under Review" } selected="selected"{/if} >Under Review</option>
                        <option value="Final Decision Available" {if  $otherErcDecision[$formLocale] == "Final Decision Available" } selected="selected"{/if} >Final Decision Available</option>
                    </select>
                </td>
            </tr>

        </table>
    </div>


<div class="separator"></div>

{*
<!--
<div id="cover">
<h3>{translate key="editor.article.cover"}</h3>

<input type="hidden" name="fileName[{$formLocale|escape}]" value="{$fileName[$formLocale]|escape}" />
<input type="hidden" name="originalFileName[{$formLocale|escape}]" value="{$originalFileName[$formLocale]|escape}" />

<table width="100%" class="data">
	<tr valign="top">
		<td class="label" colspan="2"><input type="checkbox" name="showCoverPage[{$formLocale|escape}]" id="showCoverPage" value="1" {if $showCoverPage[$formLocale]} checked="checked"{/if} /> <label for="showCoverPage">{translate key="editor.article.showCoverPage"}</label></td>
	</tr>
	<tr valign="top">
		<td width="20%" class="label">{fieldLabel name="coverPage" key="editor.article.coverPage"}</td>
		<td width="80%" class="value"><input type="file" name="coverPage" id="coverPage" class="uploadField" />&nbsp;&nbsp;{translate key="form.saveToUpload"}<br />{translate key="editor.article.coverPageInstructions"}<br />{translate key="editor.article.uploaded"}:&nbsp;{if $fileName[$formLocale]}<a href="javascript:openWindow('{$publicFilesDir}/{$fileName[$formLocale]|escape:"url"}');" class="file">{$originalFileName[$formLocale]}</a>&nbsp;<a href="{url op="removeArticleCoverPage" path=$articleId|to_array:$formLocale}" onclick="return confirm('{translate|escape:"jsparam" key="editor.article.removeCoverPage"}')">{translate key="editor.article.remove"}</a>{else}&mdash;{/if}</td>
	</tr>
	<tr valign="top">
		<td width="20%" class="label">{fieldLabel name="coverPageAltText" key="common.altText"}</td>
		<td width="80%" class="value"><input type="text" name="coverPageAltText[{$formLocale|escape}]" value="{$coverPageAltText[$formLocale]|escape}" size="40" maxlength="255" class="textField" /></td>
	</tr>
	<tr valign="top">
		<td>&nbsp;</td>
		<td class="value"><span class="instruct">{translate key="common.altTextInstructions"}</span></td>
	</tr>
	<tr valign="top">
		<td width="20%" class="label">{fieldLabel name="hideCoverPageToc" key="editor.article.coverPageDisplay"}</td>
		<td width="80%" class="value"><input type="checkbox" name="hideCoverPageToc[{$formLocale|escape}]" id="hideCoverPageToc" value="1" {if $hideCoverPageToc[$formLocale]} checked="checked"{/if} /> <label for="hideCoverPageToc">{translate key="editor.article.hideCoverPageToc"}</label></td>
	</tr>
	<tr valign="top">
		<td width="20%" class="label">&nbsp;</td>
		<td class="value"><input type="checkbox" name="hideCoverPageAbstract[{$formLocale|escape}]" id="hideCoverPageAbstract" value="1" {if $hideCoverPageAbstract[$formLocale]} checked="checked"{/if} /> <label for="hideCoverPageAbstract">{translate key="editor.article.hideCoverPageAbstract"}</label></td>
	</tr>
</table>
</div>

<div class="separator"></div>
-->
*}

{*
<!--
<div id="indexing">
<h3>{translate key="submission.indexing"}</h3>

{if $journalSettings.metaDiscipline || $journalSettings.metaSubjectClass || $journalSettings.metaSubject || $journalSettings.metaCoverage || $journalSettings.metaType}<p>{translate key="author.submit.submissionIndexingDescription"}</p>{/if}

<table width="100%" class="data">
	{if $journalSettings.metaDiscipline}
	<tr valign="top">
		<td class="label">{fieldLabel name="discipline" key="article.discipline"}</td>
		<td class="value">
			<input type="text" name="discipline[{$formLocale|escape}]" id="discipline" value="{$discipline[$formLocale]|escape}" size="40" maxlength="255" class="textField" />
			{if $currentJournal->getLocalizedSetting('metaDisciplineExamples') != ''}
			<br />
			<span class="instruct">{$currentJournal->getLocalizedSetting('metaDisciplineExamples')|escape}</span>
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	{if $journalSettings.metaSubjectClass}
	<tr valign="top">
		<td colspan="2" class="label"><a href="{$currentJournal->getLocalizedSetting('metaSubjectClassUrl')|escape}" target="_blank">{$currentJournal->getLocalizedSetting('metaSubjectClassTitle')|escape}</a></td>
	</tr>
	<tr valign="top">
		<td class="label">{fieldLabel name="subjectClass" key="article.subjectClassification"}</td>
		<td class="value">
			<input type="text" name="subjectClass[{$formLocale|escape}]" id="subjectClass" value="{$subjectClass[$formLocale]|escape}" size="40" maxlength="255" class="textField" />
			<br />
			<span class="instruct">{translate key="author.submit.subjectClassInstructions"}</span>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	{if $journalSettings.metaSubject}
	<tr valign="top">
		<td class="label">{fieldLabel name="subject" key="article.subject"}</td>
		<td class="value">
			<input type="text" name="subject[{$formLocale|escape}]" id="subject" value="{$subject[$formLocale]|escape}" size="40" maxlength="255" class="textField" />
			{if $currentJournal->getLocalizedSetting('metaSubjectExamples') != ''}
			<br />
			<span class="instruct">{$currentJournal->getLocalizedSetting('metaSubjectExamples')|escape}</span>
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	{if $journalSettings.metaCoverage}
	<tr valign="top">
		<td class="label">{fieldLabel name="coverageGeo" key="article.coverageGeo"}</td>
		<td class="value">
			<input type="text" name="coverageGeo[{$formLocale|escape}]" id="coverageGeo" value="{$coverageGeo[$formLocale]|escape}" size="40" maxlength="255" class="textField" />
			{if $currentJournal->getLocalizedSetting('metaCoverageGeoExamples') != ''}
			<br />
			<span class="instruct">{$currentJournal->getLocalizedSetting('metaCoverageGeoExamples')|escape}</span>
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	<tr valign="top">
		<td class="label">{fieldLabel name="coverageChron" key="article.coverageChron"}</td>
		<td class="value">
			<input type="text" name="coverageChron[{$formLocale|escape}]" id="coverageChron" value="{$coverageChron[$formLocale]|escape}" size="40" maxlength="255" class="textField" />
			{if $currentJournal->getLocalizedSetting('metaCoverageChronExamples') != ''}
			<br />
			<span class="instruct">{$currentJournal->getLocalizedSetting('metaCoverageChronExamples')|escape}</span>
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	<tr valign="top">
		<td class="label">{fieldLabel name="coverageSample" key="article.coverageSample"}</td>
		<td class="value">
			<input type="text" name="coverageSample[{$formLocale|escape}]" id="coverageSample" value="{$coverageSample[$formLocale]|escape}" size="40" maxlength="255" class="textField" />
			{if $currentJournal->getLocalizedSetting('metaCoverageResearchSampleExamples') != ''}
			<br />
			<span class="instruct">{$currentJournal->getLocalizedSetting('metaCoverageResearchSampleExamples')|escape}</span>
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	{if $journalSettings.metaType}
	<tr valign="top">
		<td class="label">{fieldLabel name="type" key="article.type"}</td>
		<td class="value">
			<input type="text" name="type[{$formLocale|escape}]" id="type" value="{$type[$formLocale]|escape}" size="40" maxlength="255" class="textField" />
		</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	<tr valign="top">
		<td width="20%" class="label">{fieldLabel name="language" key="article.language"}</td>
		<td width="80%" class="value">
			<input type="text" name="language" id="language" value="{$language|escape}" size="5" maxlength="10" class="textField" />
			<br />
			<span class="instruct">{translate key="author.submit.languageInstructions"}</span>
		</td>
	</tr>
</table>
</div>

<div class="separator"></div>
-->
*}

{*
<!--
<div id="supportingAgencies">
<h3>{translate key="submission.supportingAgencies"}</h3>

<p>{translate key="author.submit.submissionSupportingAgenciesDescription"}</p>

<table width="100%" class="data">
	<tr valign="top">
		<td width="20%" class="label">{fieldLabel name="sponsor" key="submission.agencies"}</td>
		<td width="80%" class="value">
			<input type="text" name="sponsor[{$formLocale|escape}]" id="sponsor" value="{$sponsor[$formLocale]|escape}" size="50" maxlength="255" class="textField" />
		</td>
	</tr>
</table>
</div>

<div class="separator"></div>
-->
*}

{*
<!--
{call_hook name="Templates::Submission::MetadataEdit::AdditionalMetadata"}

{if $journalSettings.metaCitations}
<div id="metaCitations">
<h3>{translate key="submission.citations"}</h3>

<p>{translate key="author.submit.submissionCitations"}</p>

<table width="100%" class="data">
<tr valign="top">
	<td width="20%" class="label">{fieldLabel name="citations" key="submission.citations"}</td>
	<td width="80%" class="value"><textarea name="citations" id="citations" class="textArea" rows="15" cols="50">{$citations|escape}</textarea></td>
</tr>
</table>
</div>
<script type="text/javascript">
	// Display warning when citations are being changed.
	$(function() {ldelim}
		$('#citations').change(function(e) {ldelim}
			var $this = $(this);
			var originalContent = $this.text();
			var newContent = $this.val();
			if(originalContent != newContent) {ldelim}
				// Display confirm message.
				if (!confirm('{translate key="submission.citations.metadata.changeWarning"}')) {ldelim}
					$this.val(originalContent);
				{rdelim}
			{rdelim}
		{rdelim});
	{rdelim});
</script>
<div class="separator"></div>
{/if}
-->
*}

{*
<!--
{if $isEditor}
<div id="display">
<h3>{translate key="editor.article.display"}</h3>

<table width="100%" class="data">
	<tr valign="top">
		<td width="20%" class="label">{fieldLabel name="hideAuthor" key="issue.toc"}</td>
		<td width="80%" class="value">{translate key="editor.article.hideTocAuthorDescription"}: 
			<select name="hideAuthor" id="hideAuthor" class="selectMenu">
				{html_options options=$hideAuthorOptions selected=$hideAuthor|escape}
			</select>
		</td>
	</tr>
</table>
</div>
{/if}

<div class="separator"></div>
-->
*}

<p><input type="submit" value="{translate key="submission.saveMetadata"}" class="button defaultButton"/> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="history.go(-1)" /></p>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>

</form>

{include file="common/footer.tpl"}

