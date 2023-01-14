#!/bin/bash

cd ~/src/web

npm init svelte@next $1

cd $1

npm install

touch svelte.config.js

cat > svelte.config.js << EOF
import preprocess from "svelte-preprocess";

const config = {
	preprocess: [
		preprocess({
		postcss: true,
		}),
	],
}
EOF

npm i -D tailwindcss postcss autoprefixer svelte-preprocess

touch postcss.config.cjs

cat > postcss.config.cjs << EOF
module.exports = {
	plugins: {
		tailwindcss: {},
		autoprefixer: {},
	},
}
EOF

touch src/app.css

cat > src/app.css << EOF
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

touch src/routes/__layout.svelte

cat > src/routes/__layout.svelte << EOF
<script>
	import "../app.css"
</script>

<dic class="">
	<slot></slot>
</div>
EOF

npx tailwind init tailwind.config.cjs -p

sed -i '1s/^/\/\*\* @type {import('\''tailwindcss'\'')\.Config} \*\/\n/' tailwind.config.cjs
sed -i '\%content: \[\]%a\  purge: \['\''\./src/\*\*/\*\.svelte'\'', '\''\./src/\*\*/\*\.svelte'\''\],' tailwind.config.cjs

