#!/bin/bash

DESIRED_MODE=${1:-detect}

MODE_DARK='dark'
MODE_LIGHT='light'
MODE_DETECT='detect'
VALID_MODES=($MODE_DARK $MODE_LIGHT $MODE_DETECT)

LIGHT_MODE_THEME=org.kde.breeze.desktop
DARK_MODE_THEME=Dr460nized

KONSOLE_LIGHT_MODE_COLOR_SCHEME=SolarizedLight
KONSOLE_DARK_MODE_COLOR_SCHEME=Sweet

if [[ ! ${VALID_MODES[@]} =~ $DESIRED_MODE ]]; then
	echo 'Unsupported mode given. Supported modes are: ' ${VALID_MODES[@]}
	exit 1
fi

if [[ $DESIRED_MODE == 'detect' ]]; then
	CURRENT_THEME=$(kreadconfig5 --key LookAndFeelPackage)

	if [[ -z $CURRENT_THEME ]]; then
		echo "Could not detect find current theme in ${CONFIG_FILE}. Maybe kde changed."
		exit 1
	fi
	
	if [[ $CURRENT_THEME == $DARK_MODE_THEME ]]; then
		DESIRED_MODE=light
	else
		DESIRED_MODE=dark		
	fi

	echo 'Detected mode: ' $DESIRED_MODE
fi

if [[ $DESIRED_MODE == $MODE_DARK ]]; then
	NEW_THEME=$DARK_MODE_THEME
	KONSOLE_NEW_COLOR_SCHEME=$KONSOLE_DARK_MODE_COLOR_SCHEME
	MCFLY_LIGHT=TRUE
elif [[ $DESIRED_MODE == $MODE_LIGHT ]]; then
	NEW_THEME=$LIGHT_MODE_THEME
	KONSOLE_NEW_COLOR_SCHEME=$KONSOLE_LIGHT_MODE_COLOR_SCHEME
	MCFLY_LIGHT=FALSE
fi

lookandfeeltool -a $NEW_THEME

konsoleprofile ColorScheme=$KONSOLE_NEW_COLOR_SCHEME

KONSOLE_PROFILE_PATH="${HOME}/.local/share/konsole/Garuda.profile"
sed -E "s/(ColorScheme=)(.+)/\\1${KONSOLE_NEW_COLOR_SCHEME}/" -i "${KONSOLE_PROFILE_PATH}"

echo 'If you want this change to reflect in all of your Konsole windows either run this command in all of them or re-open them.'
