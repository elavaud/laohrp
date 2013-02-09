<?php

/**
 * @file LaohrpThemePlugin.inc.php
 *
 * Copyright (c) 2011, MSB
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class LaohrpThemePlugin
 * @ingroup plugins_themes_laohrp
 *
 * @brief "Laohrp" theme plugin
 */

// $Id$


import('classes.plugins.ThemePlugin');

class LaohrpThemePlugin extends ThemePlugin {
	/**
	 * Get the name of this plugin. The name must be unique within
	 * its category.
	 * @return String name of plugin
	 */
	function getName() {
		return 'LaohrpThemePlugin';
	}

	function getDisplayName() {
		return 'Laohrp Theme';
	}

	function getDescription() {
		return 'WHO Western Pacific Region layout';
	}

	function getStylesheetFilename() {
		return 'laohrp.css';
	}
	function getLocaleFilename($locale) {
		return null; // No locale data
	}
}

?>
