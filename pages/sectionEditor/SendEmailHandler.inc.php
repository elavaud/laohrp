<?php

/**
 * @file SubmissionEditHandler.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class SubmissionEditHandler
 * @ingroup pages_sectionEditor
 *
 * @brief Handle requests for submission tracking.
 */


define('SECTION_EDITOR_ACCESS_EDIT', 0x00001);
define('SECTION_EDITOR_ACCESS_REVIEW', 0x00002);

import('pages.sectionEditor.SectionEditorHandler');
import('pages.sectionEditor.SubmissionCommentsHandler');

class SendEmailHandler extends Handler {
	/**
	 * Constructor
	 **/
	function SendEmailHandler() {
		parent::Handler();
		
		$this->addCheck(new HandlerValidatorJournal($this));
		// FIXME This is kind of evil
		$page = Request::getRequestedPage();
		if ( $page == 'sectionEditor' )  
			$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_SECTION_EDITOR)));
		elseif ( $page == 'editor' ) 		
			$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_EDITOR)));

	}
        
        function sendEmailAllUsers($send=false) {
            import('classes.mail.MailTemplate');
            $email = new MailTemplate();
            
            if ($send && !$email->hasErrors()) {
                HookRegistry::call('SendEmailHandler::sendEmailAllUsers', array(&$send));
                
                $email->send();
                
            }else {
                $sender =& Request::getUser();
                $journal =& Request::getJournal();

                $totalRecipients = 0;

                $roleDao =& DAORegistry::getDAO('RoleDAO');

                //Add all users
                $allUsers = $roleDao->getUsersByJournalId($journal->getId());
                while (!$allUsers->eof()) {
                    $user =& $allUsers->next();

                    if($sender->getId() != $user->getId()) {
                        $email->addRecipient($user->getEmail(), $user->getFullName());
                        $totalRecipients++;
                    }

                    unset($user);
                }

                $email->displayEditForm(Request::url(null, null, 'sendEmailAllUsers', 'send'), null, 'email/email_hiderecipients.tpl', array('totalRecipients' => $totalRecipients));
            }
            
            Request::redirect(null, null, 'index');
        }
        
        function sendEmailERCMembers($send=false) {
            import('classes.mail.MailTemplate');
            $email = new MailTemplate();
            
            if ($send && !$email->hasErrors()) {
                HookRegistry::call('SendEmailHandler::sendEmailERCMembers', array(&$send));
                
                $email->send();
                
            }else {
                $sender =& Request::getUser();
                $journal =& Request::getJournal();
				
                $totalRecipients = 0;

                $roleDao =& DAORegistry::getDAO('RoleDAO');
				$erc = $sender->getSecretaryEthicsCommittee();
                //Add ERC Members
                $reviewers = $roleDao->getUsersByRoleId(ROLE_ID_REVIEWER);
                while (!$reviewers->eof()) {
                    $reviewer =& $reviewers->next();
					
                    if(($sender->getId() != $reviewer->getId()) && (($erc=="UHS" && $reviewer->isUhsMember()) || ($erc=="NIOPH" && $reviewer->isNiophMember()))) {
                        $email->addRecipient($reviewer->getEmail(), $reviewer->getFullName());
                        $totalRecipients++;
                    }

                    unset($reviewer);
                }

                $email->displayEditForm(Request::url(null, null, 'sendEmailAllUsers', 'send'), null, 'email/email_hiderecipients.tpl', array('totalRecipients' => $totalRecipients));
            }
            
            Request::redirect(null, null, 'index');           
        }
        
        function sendEmailRTOs($send=false) {
            import('classes.mail.MailTemplate');
            $email = new MailTemplate();
            
            if ($send && !$email->hasErrors()) {
                HookRegistry::call('SendEmailHandler::sendEmailRTOs', array(&$send));
                
                $email->send();
                
            }else {
                $sender =& Request::getUser();
                $journal =& Request::getJournal();

                $totalRecipients = 0;

                $roleDao =& DAORegistry::getDAO('RoleDAO');

                //Add RTOs
                $authors = $roleDao->getUsersByRoleId(ROLE_ID_AUTHOR);
                while (!$authors->eof()) {
                    $author =& $authors->next();

                    if($sender->getId() != $author->getId()) {
                        $email->addRecipient($author->getEmail(), $author->getFullName());
                        $totalRecipients++;
                    }

                    unset($author);
                }

                $email->displayEditForm(Request::url(null, null, 'sendEmailAllUsers', 'send'), null, 'email/email_hiderecipients.tpl', array('totalRecipients' => $totalRecipients));
            }
            
            Request::redirect(null, null, 'index');           
        }
}

?>