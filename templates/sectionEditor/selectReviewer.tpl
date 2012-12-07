{**
 * selectReviewer.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * List reviewers and give the ability to select a reviewer.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="user.role.reviewersS"}
{include file="common/header.tpl"}
{/strip}

<script type="text/javascript">
{literal}
<!--
function sortSearch(heading, direction) {
  document.submit.sort.value = heading;
  document.submit.sortDirection.value = direction;
  document.submit.submit() ;
}
// -->
{/literal}
</script>

<div id="selectReviewer">
<h3>{*{translate key="editor.article.selectReviewer"}*}ເພີ່ມຜູ້ທົບທວນອື່ນໆ</h3>
<table class="listing">
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr class="heading" colspan="3">			
		<td colspan="3"><a href="{url op="createExternalReviewer" path=$articleId}" class="action">Create External Reviewer</a></td>		
	</tr>
	<tr><td colspan="3" class="headseparator">&nbsp;</td></tr>
	<tr>
		<td width="20%" class="heading">Role</td>
		<td width="40%" class="heading" align="left">{translate key="user.name" sort="reviewerName"}</td>	
		<td width="40%" class="heading" align="left">{translate key="common.action"}</td>
	</tr>	
	<tr><td colspan="3" class="headseparator">&nbsp;</td></tr>
	{assign var="count" value=0}
	{foreach from=$unassignedReviewers item=ercMember}
		{if ($submission->getSectionId()=='1' && $ercMember->isNiophMember()) || ($submission->getSectionId()=='2' && $ercMember->isUhsMember()) || $ercMember->isLocalizedExternalReviewer() == "Yes"}
		{assign var="count" value=$count+1}
		{assign var="reviewerId" value=$ercMember->getId()}
		<tr>
			<td width="20%" class="heading">
				{if $ercMember->isLocalizedExternalReviewer()==null || $ercMember->isLocalizedExternalReviewer()!="Yes"}
					{*ERC Member*}ຄະນະກຳມະການທົບທວນຈັນຍາທຳ
				{else}
					External Reviewer
				{/if}
			</td>
			<td width="40%" class="heading">{$ercMember->getFullname()|escape}</td>	
			<td width="40%" class="heading" align="left"><a href="{url op="selectReviewer" path=$articleId|to_array:$reviewerId}" class="action">Add and Notify as Primary Reviewer</a></td>
		</tr>			
		<tr><td colspan="3" class="separator">&nbsp;</td></tr>
		{/if}
	{/foreach}
	{if $count==0}
		<tr>
			<td colspan="3" class="nodata">{*No unassigned reviewers*}ບໍ່ມີຫຍັງ</td>
		</tr>
		<tr>
			<td colspan="3" class="endseparator">&nbsp;</td>
		</tr>
	{else}
		<tr>
			<td colspan="3" class="endseparator">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3" align="left">{$count} unassigned reviewer(s)</td>
		</tr>
	{/if}
</table>

</div>

{include file="common/footer.tpl"}

