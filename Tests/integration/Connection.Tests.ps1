#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

Describe  "Connect to a FortiGate (using HTTP)" {
    BeforeAll {
        #Disconnect "default connection"
        Disconnect-FGT -confirm:$false
    }
    It "Connect to a FortiGate (using HTTP) and check global variable" {
        Connect-FGT $ipaddress -Username $login -password $mysecpassword -httpOnly
        $DefaultFGTConnection | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.server | Should -Be $ipaddress
        $DefaultFGTConnection.invokeParams | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.port | Should -Be "80"
        $DefaultFGTConnection.httpOnly | Should -Be $true
        $DefaultFGTConnection.session | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.headers | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.version | Should -Not -BeNullOrEmpty
    }
    It "Disconnect to a FortiGate (using HTTP) and check global variable" {
        Disconnect-FGT -confirm:$false
        $DefaultFGTConnection | Should be $null
    }
    #TODO: Connect using wrong login/password
}

Describe "Connect to a fortigate (using HTTPS)" {
    BeforeAll {
        #Disconnect "default connection"
        #Disconnect-FGT -confirm:$false
    }
    It "Connect to a FortiGate (using HTTPS and -SkipCertificateCheck) and check global variable" -Skip:($httpOnly) {
        Connect-FGT $ipaddress -Username $login -password $mysecpassword -SkipCertificateCheck
        $DefaultFGTConnection | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.server | Should -Be $ipaddress
        $DefaultFGTConnection.invokeParams | Should -Not BeNullOrEmpty
        $DefaultFGTConnection.port | Should -Be "443"
        $DefaultFGTConnection.httpOnly | Should -Be $false
        $DefaultFGTConnection.session | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.headers | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.version | Should -Not -BeNullOrEmpty
    }
    It "Disconnect to a FortiGate (using HTTPS) and check global variable" -Skip:($httpOnly) {
        Disconnect-FGT -confirm:$false
        $DefaultFGTConnection | Should -Be $null
    }
    #This test only work with PowerShell 6 / Core (-SkipCertificateCheck don't change global variable but only Invoke-WebRequest/RestMethod)
    #This test will be fail, if there is valid certificate...
    It "Connect to a FortiGate (using HTTPS) and check global variable" -Skip:("Desktop" -eq $PSEdition -Or $httpOnly) {
        { Connect-FGT $ipaddress -Username $login -password $mysecpassword } | Should throw "Unable to connect (certificate)"
    }
}

Describe "Connect to a FortiGate (using multi connection)" {
    It "Connect to a FortiGate (using HTTPS and store on fgt variable)" {
        $script:fgt = Connect-FGT $ipaddress -Username $login -password $mysecpassword -httpOnly -SkipCertificate -DefaultConnection:$false
        $DefaultFGTConnection | Should -BeNullOrEmpty
        $fgt.session | Should -Not -BeNullOrEmpty
        $fgt.server | Should -Be $ipaddress
        $fgt.invokeParams | Should -Not -BeNullOrEmpty
        $fgt.port | Should -Be "80"
        $fgt.httpOnly | Should -Be $true
        $fgt.session | Should -Not -BeNullOrEmpty
        $fgt.headers | Should -Not -BeNullOrEmpty
        $fgt.version | Should -Not -BeNullOrEmpty
    }

    It "Throw when try to use Invoke-FGTRestMethod and not connected" {
        { Invoke-FGTRestMethod -uri "api/v2/cmdb/firewall/address" } | Should -Throw "Not Connected. Connect to the Fortigate with Connect-FGT"
    }

    Context "Use Multi connection for call some (Get) cmdlet (Vlan, System...)" {
        It "Use Multi connection for call Get Firewall Address" {
            { Get-FGTFirewallAddress -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Address Group" {
            { Get-FGTFirewallAddressGroup -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall IP Pool" {
            { Get-FGTFirewallIPPool -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Policy" {
            { Get-FGTFirewallPolicy -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Service Custom" {
            { Get-FGTFirewallServiceCustom -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Service Group" {
            { Get-FGTFirewallServiceGroup -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Virtual IP (VIP)" {
            { Get-FGTFirewallVip -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Router Policy" {
            { Get-FGTRouterPolicy -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Router Static" {
            { Get-FGTRouterStatic -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System DNS" {
            { Get-FGTSystemDns -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System Global" {
            { Get-FGTSystemGlobal -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System HA" {
            { Get-FGTSystemHA -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System Interface" {
            { Get-FGTSystemInterface -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System Vdom" {
            { Get-FGTSystemVdom -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System Virtual WAN Link (SD-WAN)" {
            { Get-FGTSystemVirtualWANLink -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System Zone " {
            { Get-FGTSystemZone -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get User Local" {
            { Get-FGTUserLocal -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get VPN IPsec Phase 1 Interface" {
            { Get-FGTVpnIpsecPhase1Interface -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get VPN IPsec Phase 2 Interface" {
            { Get-FGTVpnIpsecPhase2Interface -connection $fgt } | Should -Not -Throw
        }
    }

    It "Disconnect to a FortiGate (Multi connection)" {
        Disconnect-FGT -connection $fgt -confirm:$false
        $DefaultFGTConnection | Should -Be $null
    }

}