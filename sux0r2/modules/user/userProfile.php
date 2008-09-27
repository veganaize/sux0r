<?php

/**
* userProfile
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
* @author     Dac Chartrand <dac.chartrand@gmail.com>
* @copyright  2008 sux0r development group
* @license    http://www.gnu.org/licenses/agpl.html
*
*/

require_once(dirname(__FILE__) . '/../../includes/suxSocialNetwork.php');
require_once(dirname(__FILE__) . '/../../includes/suxTemplate.php');
require_once('userRenderer.php');

class userProfile {

    // Variables
    public $gtext = array();
    public $profile; // User profile array
    private $module = 'user';

    // Objects
    public $tpl;
    public $r;
    private $user;
    private $minifeed_limit = 10;


    /**
    * Constructor
    *
    * @param string $nickname nickname
    */
    function __construct($nickname) {

        $this->user = new suxUser(); // User
        $this->tpl = new suxTemplate($this->module); // Template
        $this->r = new userRenderer($this->module); // Renderer
        $this->tpl->assign_by_ref('r', $this->r); // Renderer referenced in template
        $this->gtext = suxFunct::gtext($this->module); // Language
        $this->r->text =& $this->gtext;

        // Profile
        $this->profile = $this->user->getUserByNickname($nickname);
        unset($this->profile['password']); // We don't need this

        if (!$this->profile) suxFunct::redirect(suxFunct::getPreviousURL()); // Redirect for invalid profiles

    }


    /**
    * Display user profile
    */
    function displayProfile() {

        $this->tpl->caching = 1; // Enable cache
        $cache_id = $this->profile['nickname'];

        if(!$this->tpl->is_cached('profile.tpl', $cache_id)) {

            // Full Profile
            $fullprofile = $this->user->getUser($this->profile['users_id'], true);
            unset($fullprofile['password']); // We don't need this
            if (!isset($fullprofile['dob']) || $fullprofile['dob'] == '0000-00-00') unset($fullprofile['dob']); // NULL date
            $this->r->profile =& $fullprofile; // Assign

            $this->r->title .= " | {$fullprofile['nickname']}";

            $this->r->minifeed = $this->user->getLog($this->minifeed_limit, 0, $this->profile['users_id']); // Minifeed array

        }

        $this->tpl->display('profile.tpl', $cache_id);

    }





}


?>