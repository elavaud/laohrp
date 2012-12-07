{**
 * submission.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Submission summary.
 *
 * $Id$
 *}
{strip}
{translate|assign:"pageTitleTranslated" key="submission.page.summaryS" id=$submission->getWhoId($submission->getLocale())}
{assign var="pageCrumbTitle" value="submission.summaryS"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li class="current"><a href="{url op="submission" path=$submission->getId()}">{translate key="submission.summaryS"}</a></li>
{if !$isEditor}	{if $canReview}<li><a href="{url op="submissionReview" path=$submission->getId()}">{translate key="submission.reviewS"}</a></li>{/if}{/if}
	<!--<li><a href="{url op="submissionHistory" path=$submission->getId()}">{translate key="submission.historyS"}</a></li>-->
</ul>

{include file="sectionEditor/submission/management.tpl"}

<div class="separator"></div>

{*include file="sectionEditor/submission/editors.tpl"*}
<!--
<div class="separator"></div>
-->
{include file="sectionEditor/submission/status.tpl"}

<div class="separator"></div>

{include file="submission/metadata/metadata.tpl"}

{include file="common/footer.tpl"}

