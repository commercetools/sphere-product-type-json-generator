#!/bin/bash

cat > "${HOME}/.sphere-project-credentials" << EOF
${SPHERE_PROJECT_KEY}:${SPHERE_CLIENT_ID}:${SPHERE_CLIENT_SECRET}
EOF
