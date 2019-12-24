<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'ddd' );

/** MySQL database username */
define( 'DB_USER', 'ddd' );

/** MySQL database password */
define( 'DB_PASSWORD', '575757aA' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'Pj-@$`%=UhRP2EU>Sb|]P=)$9O2Kaw5[7)M1S^ nu[eFhSB)Pa3xF>2]A,C-mSw%' );
define( 'SECURE_AUTH_KEY',  'rF0h3u=Eq{^n7/K1; yWG,7yV{|xSt|;B{W^i,kKL?BZ0A8f+=@Tgja<E$Vkwo_N' );
define( 'LOGGED_IN_KEY',    'QVIK!o2uyIcrfn$9sj8(7E_>K83U]b`uMUo!Fj2RK^u|(I+8%n;nOqQtsmJP>gWB' );
define( 'NONCE_KEY',        'XLT>R4M 6[!uRFi,LKIF(HCjM0b, 0}G@?~8%F]L^<2~&>=XaldhuD,!tvBe<Fdz' );
define( 'AUTH_SALT',        '8`:a)lXItcr.9IY,=OeQ!PJ35LSIA(pE#q!=:Zq`m2{uuP,hy$ycyCY2@rrZgB=?' );
define( 'SECURE_AUTH_SALT', '^Lt,j7H0%=`Tb/= e!sB_9|SEycu;aT*2tgNDaex^$hc0/punDFoLsU%lsgv+`l8' );
define( 'LOGGED_IN_SALT',   '9tkm2[<+@uXw#>3+mjdaH?=iFKW[?PWBny3qeDtP7kWLjC,x}L@#0$qg|xH;F+ i' );
define( 'NONCE_SALT',       'VI9c]6p5sbu>#ekB9d2`ua@}UAS*^91{%4@Ix6)**.2=Shej4;lnMB%q:.QJe%s6' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'jyymliwhjxbt_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );

if(is_admin()) {
	add_filter('filesystem_method', create_function('$a', 'return "direct";' ));
	define( 'FS_CHMOD_DIR', 0751 );
}
