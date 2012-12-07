{**
 * submission.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Author's submission summary.
 *
 * $Id$
 *}
{strip}
{translate|assign:"pageTitleTranslated" key="submission.page.summaryA" id=$submission->getWhoId($submission->getLocale())} 
{assign var="pageCrumbTitle" value="submission.summary"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li class="current"><a href="{url op="submission" path=$submission->getArticleId()}">{translate key="submission.summary"} / {translate key="submission.summaryS"}</a></li>
    <li><a href="{url op="submissionReview" path=$submission->getArticleId()}">{translate key="submission.review"} / {translate key="submission.reviewS"}</a></li>
</ul>

{include file="author/submission/management.tpl"}

{if $authorFees}
<div class="separator"></div>

{include file="author/submission/authorFees.tpl"}
{/if}

<div class="separator"></div>

{include file="author/submission/status.tpl"}

<div class="separator"></div>

{include file="submission/metadata/metadata.tpl"}

{include file="common/footer.tpl"}

