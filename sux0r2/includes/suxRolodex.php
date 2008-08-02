<?php

/**
* suxRolodex
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

// Work in progress, not finished.
// Do not include in initial sux0r 2.0 release.
// Based on the micformats hCard specification
// See: http://microformats.org/wiki/hcard

class suxRolodex {

    // Database suff
    protected $db;
    protected $inTransaction = false;
    protected $db_table = 'rolodex';


    /**
    * Constructor
    */
    function __construct() {

    	$this->db = suxDB::get();
        set_exception_handler(array($this, 'exceptionHandler'));

    }


    /**
    * Set rolodex
    *
    * @param array $info
    * @param int $id rolodex_id
    * @return bool
    */
    function setRolodex(array $info, $id = null) {

        // --------------------------------------------------------------------
        // Sanitize
        // --------------------------------------------------------------------

        if ($id != null && (!filter_var($id, FILTER_VALIDATE_INT) || $id <= 0)) throw new Exception('Invalid rolodex id');

        unset($info['id']); // Don't allow spoofing of the id in the array

        foreach ($info as $key => $val) {
            if ($key == 'url') $info[$key] = suxFunct::canonicalizeUrl($val);
            elseif ($key == 'email') $info[$key] = filter_var($val, FILTER_SANITIZE_EMAIL);
            else $info[$key] = strip_tags($val); // No Html allowed
        }

        // --------------------------------------------------------------------
        // Go!
        // --------------------------------------------------------------------

        try {
            if (!$id) {

                // Insert user
                $query = suxDB::prepareInsertQuery($this->db_table, $info);
                $st = $this->db->prepare($query);
                return $st->execute($info);

            }
            else {

                // Update user
                $query = suxDB::prepareUpdateQuery($this->db_table, $info);
                $st = $this->db->prepare($query);
                return $st->execute($info);

            }

        }
        catch (Exception $e) {
            if ($st->errorCode() == 23000) {
                // SQLSTATE 23000: Constraint violations
                return false;
            }
            else throw ($e); // Hot potato
        }


    }


    // ----------------------------------------------------------------------------
    // Exception Handler
    // ----------------------------------------------------------------------------


    /**
    * @param Exception $e an Exception class
    */
    function exceptionHandler(Exception $e) {

        if ($this->db && $this->inTransaction) {
            $this->db->rollback();
            $this->inTransaction = false;
        }

        throw($e); // Hot potato!

    }


}

/*

CREATE TABLE `rolodex` (
  `id` int(11) NOT NULL auto_increment,
  `organization_name` varchar(255) NOT NULL,
  `organization_unit` varchar(255) default NULL,
  `post_office_box` varchar(255) default NULL,
  `extended_address` varchar(255) default NULL,
  `street_address` varchar(255) default NULL,
  `locality` varchar(255) default NULL,
  `region` varchar(255) default NULL,
  `postal_code` varchar(255) default NULL,
  `country_name` varchar(255) default NULL,
  `tel` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `photo` varchar(255) default NULL,
  `latitude` varchar(255) default NULL,
  `longitude` varchar(255) default NULL,
  `note` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

*/

?>