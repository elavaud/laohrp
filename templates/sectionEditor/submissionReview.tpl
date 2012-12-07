{**
 * submissionReview.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Submission review.
 *
 * $Id$
 *}
{strip}
{translate|assign:"pageTitleTranslated" key="submission.page.reviewS" id=$submission->getWhoId($submission->getLocale())}{assign var="pageCrumbTitle" value="submission.reviewS"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li><a href="{url op="submission" path=$submission->getId()}">{translate key="submission.summaryS"}</a></li>
	<li class="current"><a href="{url op="submissionReview" path=$submission->getId()}">{translate key="submission.reviewS"}</a></li>
{**	{if $canEdit}<li><a href="{url op="submissionEditing" path=$submission->getId()}">{translate key="submission.editing"}</a></li>{/if} *}
<!--<li><a href="{url op="submissionHistory" path=$submission->getId()}">{translate key="submission.historyS"}</a></li>-->
<!-- Removed References Link - 12Apr2012 - spf
	<li><a href="{url op="submissionCitations" path=$submission->getId()}">{translate key="submission.citations"}</a></li>
-->
</ul>

{include file="sectionEditor/submission/management.tpl"}

<div class="separator"></div>

{include file="sectionEditor/submission/editorDecision.tpl"}

<div class="separator"></div>

{include file="common/footer.tpl"}

