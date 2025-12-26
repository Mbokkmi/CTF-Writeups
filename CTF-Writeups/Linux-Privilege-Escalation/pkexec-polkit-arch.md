# 🛡️ Privilege Escalation via Polkit (pkexec) – Arch Linux

**Machine:** Arch Linux
**User compromis:** `CyberRoot`
**Objectif:** Escalader les privilèges vers `root`
**Méthode:** Misconfiguration Polkit (pkexec)

## 1️⃣ Contexte

Après un accès initial au système, nous disposions d’un shell sous l’utilisateur :

```
CyberRoot
uid=1001 gid=1001 groups=1001(CyberRoot),998(wheel)
```

L’utilisateur appartient au groupe `wheel`, qui est traditionnellement utilisé pour les comptes administrateurs sous Arch Linux.

Cependant, `CyberRoot` **n’était pas autorisé via sudo** :

```
$ sudo -l
Sorry, user CyberRoot may not run sudo on archlinux.
```

Nous avons donc recherché d’autres vecteurs d’élévation de privilèges.

## 2️⃣ Enumération des binaires SUID

La commande suivante a été utilisée :

```
find / -perm -4000 2>/dev/null
```

Résultat notable :

```
/usr/bin/pkexec
/usr/bin/su
/usr/bin/passwd
/usr/bin/chsh
/usr/bin/mount
/usr/bin/umount
...
```

Le binaire **pkexec** est particulièrement critique car il permet l’exécution de commandes en tant que root via **Polkit**.

## 3️⃣ Analyse de pkexec

`pkexec` est un composant de **Polkit**, utilisé pour l’élévation de privilèges graphique et en ligne de commande.

Sur ce système :

* `CyberRoot` ∈ `wheel`
* Polkit est configuré pour permettre aux membres du groupe `wheel` d’utiliser `pkexec` après authentification.

C’est une **mauvaise configuration de sécurité**, car elle permet un contournement de `sudo`.

## 4️⃣ Exploitation

La commande suivante a été exécutée :

```
/usr/bin/pkexec
```

Le système a demandé le mot de passe de `CyberRoot`.
Après saisie, un shell root a été obtenu :

```
[root@archlinux ~]#
```

Vérification :

```
# id
uid=0(root) gid=0(root)
```

La machine est désormais totalement compromise.

## 5️⃣ Impact

Cette faille permet à **n’importe quel utilisateur membre de `wheel`** d’obtenir un accès root, même si `sudo` est correctement restreint.

Cela représente une **escalade de privilèges locale critique**.

Un attaquant ayant compromis un compte utilisateur peut :

* Lire `/etc/shadow`
* Installer des backdoors
* Modifier le système
* Désactiver les logs
* Prendre le contrôle total de la machine

## 6️⃣ Cause

Le problème ne vient pas de pkexec lui-même mais de la politique Polkit :

> Les membres du groupe `wheel` sont autorisés à exécuter des commandes via pkexec.

Cela crée un **canal d’élévation de privilèges non contrôlé**, en dehors de sudo.


## 7️⃣ Remédiation

Pour corriger cette faille :

* Restreindre Polkit :

  ```
  /etc/polkit-1/rules.d/
  ```
* Supprimer l’autorisation `wheel → pkexec`
* Utiliser uniquement `sudo` pour l’administration
* Vérifier les groupes avec :

  ```
  getent group wheel
  ```

## 8️⃣ Conclusion

Cette machine était vulnérable à une **élévation de privilèges via Polkit**.

L’attaquant n’a pas eu besoin d’un exploit kernel ni d’un bug logiciel :
une simple **mauvaise configuration de privilèges** a suffi.

> **User → pkexec → root = compromission totale**


