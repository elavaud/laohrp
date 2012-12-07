{**
 * index.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Journal index page.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitleTranslated" value=$siteTitle}
{include file="common/header.tpl"}
{/strip}

<div>
{**Changed by EL on April 12 2012*}
<p>
Lao Health Research Portal is an <i>integrated online health research management system</i> that offers substantial benefits for all stakeholders in health research. The Portal aims to improve accountability, efficiency and quality of health research conducted in Laos PDR by increasing transparency and streamlining the ethics review process.<br/><br/>
The Portal can be used to:<br/><br/>
<b>Submit at anytime from anywhere research proposals</b> for review by any of the two Research Ethics Review Committees (NECHR in NIOPH and UHS Committee) operating in the Lao PDR. Researchers need to register on the Portal. Once registered you will have a permanent account and be able to submit research proposal in a paper-less way and to track the review status of their proposals.<br/><br/>
<b>Search ongoing and completed health research</b> from December 2012 onwards through a publically accessible research registry. No registration or log-in is required to search the ongoing research.<br/><br/>
<b>Access complete research reports</b> for the research started since December 2012 once the research is completed. [Since the system is launched only December 2012, there are no research reports in the system at present, but will be added as and when a research is completed over time].<br/><br/>
<b>Access information on all the applicable guidelines, rules, and regulations</b> related to health research in Laos PDR (being added…).<br/><br/>
<b>Access a “Researchers' Directory”</b> containing information on the national and international researchers doing research in Lao PDR (will be added soon...).
</p>
</div>

{call_hook name="Templates::Index::journal"}

{if $homepageImage}
<br />
<div id="homepageImage"><img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}" width="{$homepageImage.width|escape}" height="{$homepageImage.height|escape}" {if $homepageImageAltText != ''}alt="{$homepageImageAltText|escape}"{else}alt="{translate key="common.journalHomepageImage.altText"}"{/if} /></div>
{/if}

{if $additionalHomeContent}
<br />
{$additionalHomeContent}
{/if}

{if $enableAnnouncementsHomepage}
	{* Display announcements *}
	<div id="announcementsHome">
		<h3>{translate key="announcement.announcementsHome"}</h3>
		{include file="announcement/list.tpl"}	
		<table class="announcementsMore">
			<tr>
				<td><a href="{url page="announcement"}">{translate key="announcement.moreAnnouncements"}</a></td>
			</tr>
		</table>
	</div>
{/if}

{if $issue}
	{* Display the table of contents or cover page of the current issue. *}
	<br />
	<h3>{$issue->getIssueIdentification()|strip_unsafe_html|nl2br}</h3>
	{include file="issue/view.tpl"}
{/if}

{include file="common/footer.tpl"}

