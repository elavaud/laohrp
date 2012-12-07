<?php

/**
 * @file classes/who/ProvincesOfLaosDAO.inc.php
 *
 *
 * @class ProvincesOfLaosDAO
 * @package who
 *
 * @brief Provides methods for loading localized Provinces Of Laos name data.
 *
 */

// $Id$


class ProvincesOfLaosDAO extends DAO {
	var $cache;
	/**
	 * Constructor.
	 */
	function ProvincesOfLaosDAO() {
	}

	/**
	 * Get the filename of the Asia Pacific countries registry file for the given locale.
	 * @param $locale string Name of locale (optional)
	 */
	function getFilename($locale = null) {
		if ($locale === null) $locale = Locale::getLocale();
		return "lib/pkp/locale/$locale/provincesOfLaos.xml";
	}

	function &_getCountryCache($locale = null) {
		$caches =& Registry::get('allProvincesOfLaos', true, array());
                
		if (!isset($locale)) $locale = Locale::getLocale();
                
		if (!isset($caches[$locale])) {
			$cacheManager =& CacheManager::getManager();
			$caches[$locale] = $cacheManager->getFileCache(
				'provincesOfLaos', $locale,
				array(&$this, '_countryCacheMiss')
			);

			// Check to see if the data is outdated
			$cacheTime = $caches[$locale]->getCacheTime();
			if ($cacheTime !== null && $cacheTime < filemtime($this->getFilename())) {
				$caches[$locale]->flush();
			}
		}
		return $caches[$locale];
	}

	function _countryCacheMiss(&$cache, $id) {
		$provincesOfLaos =& Registry::get('allProvincesOfLaosData', true, array());
                
                
		if (!isset($provincesOfLaos[$id])) {
			// Reload country registry file
			$xmlDao = new XMLDAO();
			$data = $xmlDao->parseStruct($this->getFilename(), array('countries', 'country'));

                        if (isset($data['countries'])) {
				foreach ($data['country'] as $countryData) {
					$provincesOfLaos[$id][$countryData['attributes']['code']] = $countryData['attributes']['name'];
				}
			}
			asort($provincesOfLaos[$id]);
			$cache->setEntireCache($provincesOfLaos[$id]);
		}
		return null;
	}

	/**
	 * Return a list of all Asia Pacific countries.
	 * @param $locale string Name of locale (optional)
	 * @return array
	 */
	function &getProvincesOfLaos($locale = null) {
		$cache =& $this->_getCountryCache($locale);
		return $cache->getContents();
	}

	/**
	 * Return a translated country name, given a code.
	 * @param $locale string Name of locale (optional)
	 * @return array
         *
         * Updated 12.22.2011 to handle multiple countries
	 */
	function getProvinceOfLaos($code, $locale = null) {
		$cache =& $this->_getCountryCache($locale);
                $countries = explode(",", $code);
                $countriesText = "";
                foreach($countries as $i => $country) {
                    $countriesText = $countriesText . $cache->get(trim($country));
                    if($i < count($countries)-1) $countriesText = $countriesText . ", ";
                }
		return $countriesText;
	}
}

?>
