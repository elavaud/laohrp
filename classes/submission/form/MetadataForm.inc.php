<?php

/**
 * @file classes/submission/form/MetadataForm.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class MetadataForm
 * @ingroup submission_form
 *
 * @brief Form to change metadata information for a submission.
 */


import('lib.pkp.classes.form.Form');

class MetadataForm extends Form {
	/** @var Article current article */
	var $article;

	/** @var boolean can edit metadata */
	var $canEdit;

	/** @var boolean can view authors */
	var $canViewAuthors;

	/** @var boolean is an Editor, can edit all metadata */
	var $isEditor;

	/**
	 * Constructor.
	 */
	function MetadataForm($article, $journal) {
                
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');

		$user =& Request::getUser();
		$roleId = $roleDao->getRoleIdFromPath(Request::getRequestedPage());
                /*
		// If the user is an editor of this article, make the entire form editable.
		$this->canEdit = false;
		$this->isEditor = false;
		if ($roleId != null && ($roleId == ROLE_ID_EDITOR || $roleId == ROLE_ID_SECTION_EDITOR)) {
			$this->canEdit = true;
			$this->isEditor = true;
		}

		$copyeditInitialSignoff = $signoffDao->getBySymbolic('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $article->getId());
		// If the user is an author and the article hasn't passed the Copyediting stage, make the form editable.
		if ($roleId == ROLE_ID_AUTHOR) {
			if ($article->getStatus() != STATUS_PUBLISHED && ($copyeditInitialSignoff == null || $copyeditInitialSignoff->getDateCompleted() == null)) {
				$this->canEdit = true;
			}
		}

		// Copy editors are also allowed to edit metadata, but only if they have
		// a current assignment to the article.
		if ($roleId != null && ($roleId == ROLE_ID_COPYEDITOR)) {
			$copyeditFinalSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_FINAL', ASSOC_TYPE_ARTICLE, $article->getId());
			if ($copyeditFinalSignoff != null && $article->getStatus() != STATUS_PUBLISHED) {
				if ($copyeditInitialSignoff->getDateNotified() != null && $copyeditFinalSignoff->getDateCompleted() == null) {
					$this->canEdit = true;
				}
			}
		}
                */
                //Added by AIM Feb 16 2012
                if ($roleId == ROLE_ID_AUTHOR || $roleId == ROLE_ID_EDITOR || $roleId == ROLE_ID_COPYEDITOR) {
                    $this->canEdit = true;
                } else {
                    $this->canEdit = false;
                }
                
		if ($this->canEdit) {
			$supportedSubmissionLocales = $journal->getSetting('supportedSubmissionLocales');
			if (empty($supportedSubmissionLocales)) $supportedSubmissionLocales = array($journal->getPrimaryLocale());

			parent::Form(
				'submission/metadata/metadataEdit.tpl',
				true,
				$article->getLocale(),
				array_flip(array_intersect(
					array_flip(Locale::getAllLocales()),
					$supportedSubmissionLocales
				))
			);
		$this->addCheck(new FormValidatorCustom($this, 'authors', 'required', 'author.submit.form.authorRequired', create_function('$authors', 'return count($authors) > 0;')));
		$this->addCheck(new FormValidatorArray($this, 'authors', 'required', 'author.submit.form.authorRequiredFields', array('firstName', 'lastName')));
		$this->addCheck(new FormValidatorArrayCustom($this, 'authors', 'required', 'user.profile.form.urlInvalid', create_function('$url, $regExp', 'return empty($url) ? true : String::regexp_match($regExp, $url);'), array(ValidatorUrl::getRegexp()), false, array('url')));
		$this->addCheck(new FormValidatorLocale($this, 'authorPhoneNumber', 'required', 'author.submit.form.authorPhoneNumber', $this->getRequiredLocale()));
		$this->addCheck(new FormValidatorLocale($this, 'scientificTitle', 'required', 'author.submit.form.scientificTitleRequired', $this->getRequiredLocale()));
		$this->addCheck(new FormValidatorLocale($this, 'publicTitle', 'required', 'author.submit.form.publicTitleRequired', $this->getRequiredLocale()));
		$this->addCheck(new FormValidatorLocale($this, 'studentInitiatedResearch', 'required', 'author.submit.form.studentInitiatedResearch', $this->getRequiredLocale()));
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$section = $sectionDao->getSection($article->getSectionId());
		$abstractWordCount = $section->getAbstractWordCount();
		if (isset($abstractWordCount) && $abstractWordCount > 0) {
			$this->addCheck(new FormValidatorCustom($this, 'abstract', 'required', 'author.submit.form.wordCountAlert', create_function('$abstract, $wordCount', 'foreach ($abstract as $localizedAbstract) {return count(explode(" ",$localizedAbstract)) < $wordCount; }'), array($abstractWordCount)));
		}
                        
                $this->addCheck(new FormValidatorLocale($this, 'keywords', 'required', 'author.submit.form.keywordsRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'startDate', 'required', 'author.submit.form.startDateRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'endDate', 'required', 'author.submit.form.endDateRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'fundsRequired', 'required', 'author.submit.form.fundsRequiredRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'selectedCurrency', 'required', 'author.submit.form.selectedCurrency', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'primarySponsor', 'required', 'author.submit.form.primarySponsor', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'multiCountryResearch', 'required', 'author.submit.form.multiCountry', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'nationwide', 'required', 'author.submit.form.nationwide', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'proposalCountry', 'required', 'author.submit.form.proposalCountryRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'researchField', 'required', 'author.submit.form.researchField', $this->getRequiredLocale()));
                //$this->addCheck(new FormValidatorLocale($this, 'technicalUnit', 'required', 'author.submit.form.technicalUnitRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'withHumanSubjects', 'required', 'author.submit.form.withHumanSubjectsRequired', $this->getRequiredLocale()));	        
                $this->addCheck(new FormValidatorLocale($this, 'proposalType', 'required', 'author.submit.form.proposalTypeRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'dataCollection', 'required', 'author.submit.form.dataCollection', $this->getRequiredLocale()));
                //$this->addCheck(new FormValidatorLocale($this, 'submittedAsPi', 'required', 'author.submit.form.submittedAsPiRequired', $this->getRequiredLocale()));
               // $this->addCheck(new FormValidatorLocale($this, 'conflictOfInterest', 'required', 'author.submit.form.conflictOfInterestRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'reviewedByOtherErc', 'required', 'author.submit.form.reviewedByOtherErcRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'otherErcDecision', 'required', 'author.submit.form.otherErcDecisionRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'industryGrant', 'required', 'author.submit.form.industryGrant', $this->getRequiredLocale()));
                //$this->addCheck(new FormValidatorLocale($this, 'nameOfIndustry', 'required', 'author.submit.form.nameOfIndustry', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'internationalGrant', 'required', 'author.submit.form.internationalGrant', $this->getRequiredLocale()));
                //$this->addCheck(new FormValidatorLocale($this, 'internationalGrantName', 'required', 'author.submit.form.internationalGrantName', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'mohGrant', 'required', 'author.submit.form.mohGrant', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'governmentGrant', 'required', 'author.submit.form.governmentGrant', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'governmentGrantName', 'required', 'author.submit.form.governmentGrantName', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'universityGrant', 'required', 'author.submit.form.universityGrant', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'selfFunding', 'required', 'author.submit.form.selfFunding', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'otherGrant', 'required', 'author.submit.form.otherGrant', $this->getRequiredLocale()));
                //$this->addCheck(new FormValidatorLocale($this, 'specifyOtherGrant', 'required', 'author.submit.form.specifyOtherGrantField', $this->getRequiredLocale()));

                } else {
			parent::Form('submission/metadata/metadataView.tpl');
		}
                /*
		// If the user is a reviewer of this article, do not show authors.
		$this->canViewAuthors = true;
		if ($roleId != null && $roleId == ROLE_ID_REVIEWER) {
			$this->canViewAuthors = false;
		}
                */
		$this->article = $article;
                
		$this->addCheck(new FormValidatorPost($this));
	}

	/**
	 * Get the default form locale.
	 * @return string
	 */
	function getDefaultFormLocale() {
		if ($this->article) return $this->article->getLocale();
		return parent::getDefaultFormLocale();
	}

	/**
	 * Initialize form data from current article.
	 */
	function initData() {

		$sectionDao =& DAORegistry::getDAO('SectionDAO');

		if (isset($this->article)) {
			$article =& $this->article;

                        //Added by AIM, 01.30.2012
                        $proposalCountryArray = $article->getProposalCountry(null);
                        $proposalCountry[$this->getFormLocale()] = explode(",", $proposalCountryArray[$this->getFormLocale()]);
						
						$multiCountryArray = $article->getMultiCountry(null);
						$multiCountry[$this->getFormLocale()] = explode(",", $multiCountryArray[$this->getFormLocale()]);
						
                        $proposalTypeArray = $article->getProposalType(null);
                        $proposalType[$this->getFormLocale()] = explode("+", $proposalTypeArray[$this->getFormLocale()]);
                        $otherProposalType = "";
                        
                        $researchFieldArray = $article->getResearchField(null);
                        $researchField[$this->getFormLocale()] = explode("+", $researchFieldArray[$this->getFormLocale()]);

                        //Added by AIM 02.16.2012
                        $articleDao =& DAORegistry::getDAO('ArticleDAO');
                        /*$proposalTypes = $articleDao->getProposalTypes();
                        $proposalTypeCodes = array();
                        foreach ($proposalTypes as $i => $type) {
                            array_push($proposalTypeCodes, $type['code']);
                        }
                        

                        foreach($proposalType[$this->getFormLocale()] as $i => $type) {
                            if(!in_array($type, $proposalTypeCodes) && $type != "") {
                                preg_match('/\((.*)\)/', $type, $matches);
                                $otherProposalType = $matches[1];
                                $proposalType[$this->getFormLocale()][$i] = "OTHER";
                            }
                        }*/
                        
			$this->_data = array(
				'authors' => array(),
				'authorPhoneNumber' => $article->getAuthorPhoneNumber(null),
				'scientificTitle' => $article->getScientificTitle(null), // Localized
				'publicTitle' => $article->getPublicTitle(null), // Localized
				//
				'studentInitiatedResearch' => $article->getStudentInitiatedResearch(null),
				'studentInstitution' => $article->getStudentInstitution(null), 
				'academicDegree' => $article->getAcademicDegree(null),
				//
				'abstract' => $article->getAbstract(null), // Localized
				'discipline' => $article->getDiscipline(null), // Localized
				'subjectClass' => $article->getSubjectClass(null), // Localized
				'subject' => $article->getSubject(null), // Localized
				'coverageGeo' => $article->getCoverageGeo(null), // Localized
				'coverageChron' => $article->getCoverageChron(null), // Localized
				'coverageSample' => $article->getCoverageSample(null), // Localized
				'type' => $article->getType(null), // Localized
				'language' => $article->getLanguage(),
				'sponsor' => $article->getSponsor(null), // Localized
				'section' => $sectionDao->getSection($article->getSectionId()),
				'citations' => $article->getCitations(),
                                /***********************************************************
                                 *  Init code for additional proposal metadata
                                 *  Added by: Anne Ivy Mirasol
                                 *  Last Edited: Dec. 24, 2011
                                 ***********************************************************/
                                 
                                 //Comment out by EL on April 12 2012

                                 //Returned getObjectives spf April 17, 2012
				 'objectives' => $article->getObjectives(null),
                                 
                                 'keywords' => $article->getKeywords(null),
                                 'startDate' => $article->getStartDate(null),
                                 'endDate' => $article->getEndDate(null),
                                 'fundsRequired' => $article->getFundsRequired(null),
                                 'selectedCurrency' => $article->getSelectedCurrency(null),
                                 'primarySponsor' => $article->getPrimarySponsor(null),
                                 'secondarySponsors' => $article->getSecondarySponsors(null),
                                 'multiCountryResearch' => $article->getMultiCountryResearch(null),
                                 'multiCountry' => $multiCountry,
                                 'nationwide' => $article->getNationwide(null),
                                 'proposalCountry' => $proposalCountry,
                                 'researchField' => $researchField,
                                 'technicalUnit' => $article->getTechnicalUnit(null),
                                 'withHumanSubjects' => $article->getWithHumanSubjects(null),
                                 'proposalType' => $proposalType,
                                 'otherProposalType' => $otherProposalType,
                                 'dataCollection' => $article->getDataCollection(null),
                                 'submittedAsPi' => $article->getSubmittedAsPi(null),
                                 'conflictOfInterest' => $article->getConflictOfInterest(null),
                                 'reviewedByOtherErc' => $article->getReviewedByOtherErc(null),
                                 'otherErcDecision' => $article->getOtherErcDecision(null),
                                 'rtoOffice' => $article->getRtoOffice(null),
                                 'industryGrant' => $article->getIndustryGrant(null),
                                 'nameOfIndustry' => $article->getNameOfIndustry(null),
                                 'internationalGrant' => $article->getInternationalGrant(null),
                                 'internationalGrantName' => $article->getInternationalGrantName(null),
                                 'mohGrant' => $article->getMohGrant(null),
                                 'governmentGrant' => $article->getGovernmentGrant(null),
                                 'governmentGrantName' => $article->getGovernmentGrantName(null),
                                 'universityGrant' => $article->getUniversityGrant(null),
                                 'selfFunding' => $article->getSelfFunding(null),
                                 'otherGrant' => $article->getOtherGrant(null),
                                 'specifyOtherGrant' => $article->getSpecifyOtherGrant(null)
			);
                        
			$authors =& $article->getAuthors();
			for ($i=0, $count=count($authors); $i < $count; $i++) {
				array_push(
					$this->_data['authors'],
					array(
						'authorId' => $authors[$i]->getId(),
						'firstName' => $authors[$i]->getFirstName(),
						'middleName' => $authors[$i]->getMiddleName(),
						'lastName' => $authors[$i]->getLastName(),
						'affiliation' => $authors[$i]->getAffiliation(null),
						'country' => $authors[$i]->getCountry(),
						'email' => $authors[$i]->getEmail(),
						'url' => $authors[$i]->getUrl(),
						'competingInterests' => $authors[$i]->getCompetingInterests(null),
						'biography' => $authors[$i]->getBiography(null)
					)
				);
				if ($authors[$i]->getPrimaryContact()) {
					$this->setData('primaryContact', $i);
				}
			}
		}
		return parent::initData();
	}

	/**
	 * Get the field names for which data can be localized
	 * @return array
	 */
	function getLocaleFieldNames() {
                /*******************************************************************
                 * Edited by Anne Ivy Mirasol -- Addition of fields
                 * Last Updated: May 3, 2011
                 *******************************************************************/
		return array('authorPhoneNumber', 'scientificTitle', 'publicTitle', 'studentInitiatedResearch', 'studentInstitution', 'academicDegree','abstract', 'subjectClass', 'subject', 'coverageGeo', 'coverageChron', 'coverageSample', 'type', 'sponsor', 'objectives', 'keywords', 'startDate', 'endDate', 'fundsRequired', 'selectedCurrency', 'primarySponsor', 'secondarySponsors', 'multiCountryResearch', 'multiCountry', 'nationwide', 'proposalCountry', 'researchField', /* 'technicalUnit',*/ 'withHumanSubjects','proposalType', 'dataCollection', 'submittedAsPi', 'conflictOfInterest', 'reviewedByOtherErc', 'otherErcDecision', 'rtoOffice', 'industryGrant', 'nameOfIndustry', 'internationalGrant', 'internationalGrantName', 'mohGrant', 'governmentGrant', 'governmentGrantName', 'universityGrant', 'selfFunding', 'otherGrant', 'specifyOtherGrant');

	}

	/**
	 * Display the form.
	 */
	function display() {
		$journal =& Request::getJournal();
		$settingsDao =& DAORegistry::getDAO('JournalSettingsDAO');
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$sectionDao =& DAORegistry::getDAO('SectionDAO');

		Locale::requireComponents(array(LOCALE_COMPONENT_OJS_EDITOR)); // editor.cover.xxx locale keys; FIXME?

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('articleId', isset($this->article)?$this->article->getId():null);
		$templateMgr->assign('journalSettings', $settingsDao->getJournalSettings($journal->getId()));
		$templateMgr->assign('rolePath', Request::getRequestedPage());
		$templateMgr->assign('canViewAuthors', $this->canViewAuthors);

		$countryDao =& DAORegistry::getDAO('CountryDAO');
		$templateMgr->assign('countries', $countryDao->getCountries());

		$templateMgr->assign('helpTopicId','submission.indexingAndMetadata');
		if ($this->article) {
			$templateMgr->assign_by_ref('section', $sectionDao->getSection($this->article->getSectionId()));
		}

		if ($this->isEditor) {
			import('classes.article.Article');
			$hideAuthorOptions = array(
				AUTHOR_TOC_DEFAULT => Locale::Translate('editor.article.hideTocAuthorDefault'),
				AUTHOR_TOC_HIDE => Locale::Translate('editor.article.hideTocAuthorHide'),
				AUTHOR_TOC_SHOW => Locale::Translate('editor.article.hideTocAuthorShow')
			);
			$templateMgr->assign('hideAuthorOptions', $hideAuthorOptions);
			$templateMgr->assign('isEditor', true);
		}

                /*********************************************************************
                 *  Get proposal types from database
                 *  Added by:  Anne Ivy Mirasol
                 *  Last Updated: April 25, 2011
                 *********************************************************************/
                $articleDao =& DAORegistry::getDAO('ArticleDAO');
                $proposalTypes = $articleDao->getProposalTypes();
                $templateMgr->assign('proposalTypes', $proposalTypes);

                /*********************************************************************
                 *  Get research fields from database
                 *  Added by:  EL
                 *  Last Updated: May, 2012
                 *********************************************************************/
                $researchFields = $articleDao->getResearchFields();
                $templateMgr->assign('researchFields', $researchFields);

                /*********************************************************************
                 *  Get list of provinces of Laos from the XML file
                 *  Added by:  Anne Ivy Mirasol
                 *  Last Updated: May 3, 2011
                 *********************************************************************/

                $provinceDAO =& DAORegistry::getDAO('ProvincesOfLaosDAO');
                $proposalCountries =& $provinceDAO->getProvincesOfLaos();
                $templateMgr->assign_by_ref('proposalCountries', $proposalCountries);


                /*********************************************************************
                 *  Get list of WPRO technical units from the XML file
                 *  Added by:  Anne Ivy Mirasol
                 *  Last Updated: May 3, 2011
                 *********************************************************************/

                $technicalUnitDAO =& DAORegistry::getDAO('TechnicalUnitDAO');
                $technicalUnits =& $technicalUnitDAO->getTechnicalUnits();
                $templateMgr->assign_by_ref('technicalUnits', $technicalUnits);

		parent::display();
	}


	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(
			array(
				'authors',
				'deletedAuthors',
				'primaryContact',
				'authorPhoneNumber',
				'scientificTitle',
				'publicTitle',
				'studentInitiatedResearch',
				'studentInstitution',
				'academicDegree',
				'abstract',
				'discipline',
				'subjectClass',
				'subject',
				'coverageGeo',
				'coverageChron',
				'coverageSample',
				'type',
				'language',
				'sponsor',
				'citations',
                                /*********************************************************
                                 *  Read input code for additional proposal metadata
                                 *  Added by: Anne Ivy Mirasol
                                 *  Last Edited: May 3, 2011
                                 *********************************************************/
                                 
                                 //Comment out by EL on April 12 2012

                                 //Returned by SPF on April 17, 2012
				 'objectives',
                                 
                                 'keywords',
                                 'startDate',
                                 'endDate',
                                 'fundsRequired',
                                 'selectedCurrency',
                                 'primarySponsor',
                                 'secondarySponsors',
                                 'multiCountryResearch',
                                 'multiCountry',
                                 'nationwide',
                                 'proposalCountry',
                                 'researchField',
                                 'technicalUnit',
                                 'withHumanSubjects',
                                 'proposalType',
                                 'dataCollection',
                                 'submittedAsPi',
                                 'conflictOfInterest',
                                 'reviewedByOtherErc',
                                 'otherErcDecision',
                                 'rtoOffice',
                                 'industryGrant',
                                 'nameOfIndustry',
                                 'internationalGrant',
                                 'internationalGrantName',
                                 'mohGrant',
                                 'governmentGrant',
                                 'governmentGrantName',
                                 'universityGrant',
                                 'selfFunding',
                                 'otherGrant',
                                 'specifyOtherGrant'
			)
		);

		// Load the section. This is used in the step 2 form to
		// determine whether or not to display indexing options.
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$this->_data['section'] =& $sectionDao->getSection($this->article->getSectionId());

		if ($this->_data['section']->getAbstractsNotRequired() == 0) {
			$this->addCheck(new FormValidatorLocale($this, 'abstract', 'required', 'author.submit.form.abstractRequired', $this->getRequiredLocale()));
		}
	}

	/**
	 * Save changes to article.
	 * @param $request PKPRequest
	 * @return int the article ID
	 */
	function execute(&$request) {
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$authorDao =& DAORegistry::getDAO('AuthorDAO');
		$article =& $this->article;

		// Retrieve the previous citation list for comparison.
		$previousRawCitationList = $article->getCitations();

		// Update article
		$article->setAuthorPhoneNumber($this->getData('authorPhoneNumber'), null);
		$article->setScientificTitle($this->getData('scientificTitle'), null); // Localized
		$article->setPublicTitle($this->getData('publicTitle'), null);// Localized
		$article->setStudentInitiatedResearch($this->getData('studentInitiatedResearch'), null);
		$article->setStudentInstitution($this->getData('studentInstitution'), null);
		$article->setAcademicDegree($this->getData('academicDegree'), null);
		$article->setAbstract($this->getData('abstract'), null); // Localized
		$article->setDiscipline($this->getData('discipline'), null); // Localized
		$article->setSubjectClass($this->getData('subjectClass'), null); // Localized
		$article->setSubject($this->getData('subject'), null); // Localized
		$article->setCoverageGeo($this->getData('coverageGeo'), null); // Localized
		$article->setCoverageChron($this->getData('coverageChron'), null); // Localized
		$article->setCoverageSample($this->getData('coverageSample'), null); // Localized
		$article->setType($this->getData('type'), null); // Localized
		$article->setLanguage($this->getData('language'));
		$article->setSponsor($this->getData('sponsor'), null); // Localized
		$article->setCitations($this->getData('citations'));
		if ($article->getSubmissionProgress() <= $this->step) {
			$article->stampStatusModified();
			$article->setSubmissionProgress($this->step + 1);
		}

        /***********************************************************
         *  Edited by: AIM
         *  Last Updated: Jan 30, 2012
         ***********************************************************/
                 
        //Comment out by EL on April 13 2012  
        //Returned setObjectives by SPF April 17, 2012
	$article->setObjectives($this->getData('objectives'), null); // Localized
                
        $article->setKeywords($this->getData('keywords'), null); // Localized
        $article->setStartDate($this->getData('startDate'), null); // Localized
        $article->setEndDate($this->getData('endDate'), null); // Localized
        $article->setFundsRequired($this->getData('fundsRequired'), null); // Localized
        $article->setSelectedCurrency($this->getData('selectedCurrency'), null);
        $article->setPrimarySponsor($this->getData('primarySponsor'), null);
        $article->setSecondarySponsors($this->getData('secondarySponsors'), null);
        $article->setMultiCountryResearch($this->getData('multiCountryResearch'), null);
		$article->setNationwide($this->getData('nationwide'), null);
		
        //Convert multiple provinces to CSV string
        $proposalCountryArray = $this->getData('proposalCountry');
        $proposalCountry[$this->getFormLocale()] = implode(",", $proposalCountryArray[$this->getFormLocale()]);
        $article->setProposalCountry($proposalCountry, null); // Localized

        //Convert multiple proposal types to CSV string, Jan 30 2012
        $proposalTypeArray = $this->getData('proposalType');
        /*foreach($proposalTypeArray[$this->getFormLocale()] as $i => $type) {
        	if($type == "OTHER") {
        		$otherType = trim(str_replace("+", ",", $request->getUserVar('otherProposalType')));
            	if($otherType != "") $proposalTypeArray[$this->getFormLocale()][$i] = "OTHER (". $otherType .")";
        	}
        }*/
        
        $proposalType[$this->getFormLocale()] = implode("+", $proposalTypeArray[$this->getFormLocale()]);
        $article->setProposalType($proposalType, null); // Localized
        
        //Convert multiple research fields to CSV
        $researchFieldArray = $this->getData('researchField');
        $researchField[$this->getFormLocale()] = implode("+", $researchFieldArray[$this->getFormLocale()]);
        $article->setResearchField($researchField, null);
        
        //Convert multiple countries to CSV
        $multiCountryArray = $this->getData('multiCountry');
        $multiCountry[$this->getFormLocale()] = implode(",", $multiCountryArray[$this->getFormLocale()]);
        $article->setMultiCountry($multiCountry, null);
        
        $article->setDataCollection($this->getData('dataCollection'), null);
        $article->setTechnicalUnit($this->getData('technicalUnit'), null); // Localized
        $article->setWithHumanSubjects($this->getData('withHumanSubjects'),null); // Localized
	    $article->setSubmittedAsPi($this->getData('submittedAsPi'), null); // Localized
        $article->setConflictOfInterest($this->getData('conflictOfInterest'), null); // Localized
        $article->setReviewedByOtherErc($this->getData('reviewedByOtherErc'), null); // Localized
        $article->setOtherErcDecision($this->getData('otherErcDecision'), null); // Localized
        $article->setRtoOffice($this->getData('rtoOffice'), null);//Localized
        
        $article->setIndustryGrant($this->getData('industryGrant'), null);
        $article->setNameOfIndustry($this->getData('nameOfIndustry'), null); 
        $article->setInternationalGrant($this->getData('internationalGrant'), null); 
        $article->setInternationalGrantName($this->getData('internationalGrantName'), null); 
        $article->setMohGrant($this->getData('mohGrant'), null);
        $article->setGovernmentGrant($this->getData('governmentGrant'), null);
        $article->setGovernmentGrantName($this->getData('governmentGrantName'), null); 
        $article->setUniversityGrant($this->getData('universityGrant'), null); 
        $article->setSelfFunding($this->getData('selfFunding'), null); 
        $article->setOtherGrant($this->getData('otherGrant'), null); 
        $article->setSpecifyOtherGrant($this->getData('specifyOtherGrant'), null);         
        /***************** END OF EDIT *****************************/

        //
        // Update authors
		$authors = $this->getData('authors');
		for ($i=0, $count=count($authors); $i < $count; $i++) {
			if ($authors[$i]['authorId'] > 0) {
			// Update an existing author
				$author =& $article->getAuthor($authors[$i]['authorId']);
				$isExistingAuthor = true;
			} else {
				// Create a new author
				$author = new Author();
				$isExistingAuthor = false;
			}

			if ($author != null) {
				$author->setSubmissionId($article->getId());
				$author->setFirstName($authors[$i]['firstName']);
				$author->setMiddleName($authors[$i]['middleName']);
				$author->setLastName($authors[$i]['lastName']);
				$author->setAffiliation($authors[$i]['affiliation'], null);
				$author->setCountry($authors[$i]['country']);
				$author->setEmail($authors[$i]['email']);
				$author->setUrl($authors[$i]['url']);
				if (array_key_exists('competingInterests', $authors[$i])) {
					$author->setCompetingInterests($authors[$i]['competingInterests'], null);
				}
				//$author->setBiography($authors[$i]['biography'], null);  //AIM, 12.12.2011
				$author->setPrimaryContact($this->getData('primaryContact') == $i ? 1 : 0);
				$author->setSequence($authors[$i]['seq']);

				if ($isExistingAuthor == false) {
					$article->addAuthor($author);
				}
			}
			unset($author);
		}

		// Remove deleted authors
		$deletedAuthors = explode(':', $this->getData('deletedAuthors'));
		for ($i=0, $count=count($deletedAuthors); $i < $count; $i++) {
			$article->removeAuthor($deletedAuthors[$i]);
		}

		parent::execute();

		// Save the article
		$articleDao->updateArticle($article);

		// Update references list if it changed.
		$citationDao =& DAORegistry::getDAO('CitationDAO');
		$rawCitationList = $article->getCitations();
		if ($previousRawCitationList != $rawCitationList) {
			$citationDao->importCitations($request, ASSOC_TYPE_ARTICLE, $article->getId(), $rawCitationList);
		}
		return $this->articleId;
	}

	/**
	 * Determine whether or not the current user is allowed to edit metadata.
	 * @return boolean
	 */
	function getCanEdit() {
		return $this->canEdit;
	}
}

?>
