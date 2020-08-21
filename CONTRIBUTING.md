# Contributing

## Writing Function Files

Functions can be grouped in one file when it's about the same api but using different method (GET/PUT/POST/DELETE). For example:

```no-highlight
device-types/Acme/BFR-1000.yaml
device-types/Acme/BFR-2000.yaml
```

When writing new definitions, there are some important guidelines to follow:

* Every unique model number requires a discrete definition file, even if the set of components is identical.
* Definition files must end in `.yaml`, or `.yml`
* Use proper, human-friendly names when creating manufacturer directories (e.g. `Alcatel-Lucent` versus `alcatel`).
* Include only components which are fixed to the chassis. Optional modular components should be omitted from the
  definition. (Note that this does not exclude field-replaceable hardware that is expected to always be present, such
  as power supplies.)
* Name components exactly as they appear in the device's operating system (as opposed to the physical chassis label, if
  different).
* Use the complete form of interface names where applicable. For example, use `TenGigabitEthernet1/2/3` instead of
`Te1/2/3`.

Additionally, be sure to adhere to the following style guidance:

* Do not begin the file with three dashes (`---`); YAML directives are not supported.
* Use two spaces for indenting.
* Specify a device type's attributes before listing its components.
* Avoid encapsulating YAML values in quotes unless necessary to avoid a syntax error.
* End each definition file with a blank line.

## The Contribution Workflow

The process of submitting new definitions to the library is as follows:

1. Verify that the proposed function does not duplicate or conflict with an existing function.
2. Next step, [Fork](https://github.com/FortiPower/PowerFGT.git) the GitHub project and create a new branch to hold your
   proposed changes. The branch should be named respecting this format `<menu>-<item>` (for example, `System-Interface`).
3. Introduce the new content exactly in the right folder (All functions need to be place under PowerFGT/PowerFGT/Public/cmdb/<menu>, and all tests need to be placed in PowerFGT/Tests/integration).
4. Submit a [pull request](https://github.com/FortiPower/PowerFGT/compare) to merge your new
   branch into the `master` branch. Include a brief description of the changes introduced in the PR.
5. A maintainer will review your PR and take one of three actions:
   * Accept and merge it
   * Request revisions
   * Close the PR citing a reason