

buildschema()
    {
    source /trebula/project.properties

    rm -rf /trebula/build
    mkdir --parents /trebula/build

    /tmp/venv/bin/python \
        /isobeon/schema-processor.py \
            "/trebula/schema/${schemapath:?}/execution-broker.yaml" \
            "/trebula/build/execution-broker-${schemaversion:?}.yaml"
    }

buildpythonclient()
    {
    source /trebula/project.properties

    buildschema

    schemafile=/trebula/build/execution-broker-${schemaversion:?}.yaml
    buildpath=/trebula/python/client/build

    rm -rf \
        "${buildpath:?}"
    mkdir --parents \
        "${buildpath:?}"

    java -jar "${generatorFullPath}" \
        generate \
        --generator-name python \
        --input-spec "${schemafile:?}" \
        --output     "${buildpath:?}" \
        --package-name "calycopis_openapi_client" \
        --additional-properties "packageUrl=https://github.com/ivoa/Calycopis-schema" \
        --additional-properties "packageVersion=${schemaversion:?}" \
        --additional-properties "projectName=calycopis-openapi-client"

    /tmp/venv/bin/python \
        -m build \
            "${buildpath:?}"



    }

buildjavaclient()
    {
    source /trebula/project.properties

    buildschema

    pushd /trebula/codegen/java/client/

        rm -rf build
        mkdir --parents build
        cat > build/build.properties << EOF
trebula.schema.file=/trebula/build/execution-broker-${schemaversion:?}.yaml
EOF

        ./mvnw clean install

    popd

    }

buildjavaspring()
    {
    source /trebula/project.properties

    buildschema

    pushd /trebula/codegen/java/spring/

        rm -rf build
        mkdir --parents build
        cat > build/build.properties << EOF
trebula.schema.file=/trebula/build/execution-broker-${schemaversion:?}.yaml
EOF

        ./mvnw clean install

    popd

    }

