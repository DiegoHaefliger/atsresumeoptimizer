#!/usr/bin/env bash
set -euo pipefail

VERSION_FORMAT='^[0-9]+\.[0-9]+\.[0-9]+$'

cd "$(git rev-parse --show-toplevel)"

version="${1:-}"
if [[ -z "$version" ]]; then
	read -r -p "Versão da tag (ex.: 1.1.0): " version
fi
version="${version#v}"
tag="v$version"

if [[ ! "$version" =~ $VERSION_FORMAT ]]; then
	echo "Versão inválida: use MAJOR.MINOR.PATCH (ex.: 1.1.0)." >&2
	exit 1
fi
if git rev-parse -q --verify "refs/tags/$tag" >/dev/null || git ls-remote --exit-code --tags origin "$tag" >/dev/null 2>&1; then
	echo "A tag $tag já existe." >&2
	exit 1
fi
if [[ -n "$(git status --porcelain)" ]]; then
	echo "Há mudanças não commitadas no repositório raiz." >&2
	exit 1
fi

git checkout main
git pull --ff-only
git submodule update --init --remote backend front

if [[ -n "$(git status --porcelain backend front)" ]]; then
	echo
	git submodule summary
	read -r -p "Atualizar os submódulos acima e abrir PR? [s/N] " answer
	[[ "$answer" =~ ^[sS]$ ]] || exit 1

	branch="chore/release-$tag"
	git checkout -b "$branch"
	git add backend front
	git commit -m "chore: submódulos na main para a $tag"
	git push -u origin "$branch"
	gh pr create --base main --head "$branch" --title "chore: submódulos na main para a $tag" \
		--body "Atualiza os submódulos para o main de cada repositório antes da $tag."
	gh pr merge "$branch" --merge --delete-branch
	git checkout main
	git pull --ff-only
fi

read -r -p "Criar e enviar a tag $tag a partir de $(git rev-parse --short HEAD)? [s/N] " answer
[[ "$answer" =~ ^[sS]$ ]] || exit 1

git tag -a "$tag" -m "ATS Resume Optimizer $version"
git push origin "$tag"
echo "Tag $tag enviada. O workflow de release foi disparado."
