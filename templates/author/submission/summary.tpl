{**
 * summary.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the author's submission summary table.
 *
 * $Id$
 *}
<div id="submission">
<h3>{translate key="article.submission"} / ການສົ່ງບົດສະຫນີ</h3>

<table width="100%" class="data">
	<tr>
		<td width="30%" class="label">{translate key="article.authors"} / {translate key="article.authorsS"}</td>
		<td width="70%">
                        
			{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$submission->getAuthorEmails() subject=$submission->getLocalizedTitle() articleId=$submission->getArticleId()}
			{$submission->getAuthorString()|escape} {icon name="mail" url=$url}
                        
                        
			{*{$submission->getFirstAuthor()|escape}*}
		</td>
	</tr>
	<tr>
		<td class="label">{translate key="article.title"} / {translate key="article.titleS"}</td>
		<td>{$submission->getLocalizedTitle()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">{translate key="section.section"} / ຄະນະກຳມະການຈັນຍາທຳ</td>
		<td>{$submission->getSectionTitle()|escape}</td>
	</tr>
	<tr>
		<td class="label">{translate key="user.role.editor"} / ເລຂາ</td>
		<td>
			{assign var=editAssignments value=$submission->getEditAssignments()}
			{foreach from=$editAssignments item=editAssignment}
				{assign var=emailString value=$editAssignment->getEditorFullName()|concat:" <":$editAssignment->getEditorEmail():">"}
				{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$emailString|to_array subject=$submission->getLocalizedTitle()|strip_tags articleId=$submission->getArticleId()}
				{$editAssignment->getEditorFullName()|escape} {icon name="mail" url=$url}
				{if !$editAssignment->getCanEdit() || !$editAssignment->getCanReview()}
					{if $editAssignment->getCanEdit()}
						({translate key="submission.editing"})
					{else}
						({translate key="submission.review"})
					{/if}
				{/if}
				<br/>
			{foreachelse}
				{translate key="common.noneAssigned"}
			{/foreach}
		</td>
	</tr>
</table>
</div>

