#!/bin/bash

ROOT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$ROOT_DIR/../.env"

PROJECT_DIR="${ROOT_DIR}/../${D_SOURCE_DIR}"

echo "--=[ Fixing the files and folders permissions ]=--";
echo "[ base path: \"$PROJECT_DIR\" ]"

echo -ne "[ (step 1/10) set owner ("$D_USER_ID":"$D_GROUP_ID") .............. in progress ] \r";
chown -R "${D_USER_ID}:${D_GROUP_ID}" "${PROJECT_DIR}"
echo "[ (step 1/10) set owner ("$D_USER_ID":"$D_GROUP_ID") ..................... done ]";

echo -ne "[ (step 2/10) set 644 for \""$D_SOURCE_DIR"\" .............. in progress ] \r";
#chmod -R 664 "${PROJECT_DIR}"
echo "[ (step 2/10) set 644 for \""$D_SOURCE_DIR"\" ..................... done ]";

echo -ne "[ (step 3/10) set 755 for all directories .............. in progress ] \r";
find "$PROJECT_DIR" -type d -exec chmod 755 {} \;
echo "[ (step 3/10) set 755 for all directories ..................... done ]";

echo -ne "[ (step 4/10) set 777 for \""$D_SOURCE_DIR"/var\" .............. in progress ] \r";
chmod -R 777 "${PROJECT_DIR}/var"
echo "[ (step 4/10) set 777 for \""$D_SOURCE_DIR"/var\" ..................... done ]";

echo -ne "[ (step 5/10) set 777 for \""$D_SOURCE_DIR"/var\" .............. in progress ] \r";
chmod -R 777 "${PROJECT_DIR}/generated"
echo "[ (step 5/10) set 777 for \""$D_SOURCE_DIR"/var\" ..................... done ]";

echo -ne "[ (step 6/10) set 777 for \""$D_SOURCE_DIR"/pub/media\" .............. in progress ] \r";
chmod -R 777 "${PROJECT_DIR}/pub/media"
echo "[ (step 6/10) set 777 for \""$D_SOURCE_DIR"/pub/media\" ..................... done ]";

echo -ne "[ (step 7/10) set 777 for \""$D_SOURCE_DIR"/pub/static\" .............. in progress ] \r";
chmod -R 777 "${PROJECT_DIR}/pub/static"
echo "[ (step 7/10) set 777 for \""$D_SOURCE_DIR"/pub/static\" ..................... done ]";

echo -ne "[ (step 8/10) set 777 for \""$D_SOURCE_DIR"/app/etc\" .............. in progress ] \r";
chmod -R 777 "${PROJECT_DIR}/app/etc"
echo "[ (step 8/10) set 777 for \""$D_SOURCE_DIR"/app/etc\" ..................... done ]";

echo -ne "[ (step 9/10) set 664 for \""$D_SOURCE_DIR"/app/etc/*.xml\" .............. in progress ] \r";
find "${PROJECT_DIR}/app/etc" -type f -name "*.xml" -exec chmod 664 {} \;
echo "[ (step 9/10) set 664 for \""$D_SOURCE_DIR"/app/etc/*.xml\" ..................... done ]";

echo -ne "[ (step 10/10) set +x for \""$D_SOURCE_DIR"/bin/magento\" .............. in progress ] \r";
chmod u+x "${PROJECT_DIR}/bin/magento"
echo "[ (step 10/10) set +x for \""$D_SOURCE_DIR"/bin/magento\" ..................... done ]";

echo "--=[ DONE ]=--";
