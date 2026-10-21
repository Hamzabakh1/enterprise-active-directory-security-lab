# Atlas Enterprise Technologies — shared reference architecture

Fictional organization: 200 synthetic employees across IT, Human Resources, Finance, Operations, Engineering and Management. Planned forest: `corp.example.test` (lab only). The enterprise topology is **DOCUMENTED ONLY**. Windows Server 2025 Standard Evaluation (Server Core) is installed on the isolated `Atlas-DC01` pilot VM, but no AD forest or tenant was provisioned.

![Atlas reference topology](assets/diagrams/enterprise-topology.svg)

The SVG is an editable reference diagram. The [Mermaid source](assets/diagrams/enterprise-topology.mmd) provides the detailed system connections. Neither diagram is evidence of deployment.

| Segment | CIDR | Systems | Administrative rule |
|---|---|---|---|
| DC | 192.0.2.0/27 | DC01 .10, DC02 .11 | Admin from MGMT01 only; DNS, Kerberos, LDAP, replication per approved firewall matrix |
| Applications | 192.0.2.32/27 | FS01 .40, EX01 .50, EX02 .51 optional, SYNC01 .55 | Service-specific east/west access |
| Management | 192.0.2.64/27 | MGMT01 .70 | Privileged access workstation principles; jump path and logging |
| Workstations | 192.0.2.96/27 | CLIENT01 .100 | No direct administrative access to DCs |
| Cloud | N/A | Entra ID, Microsoft 365, Exchange Online | Outbound TLS from sync/management; separate tenant trust boundary |

All addresses are RFC 5737 examples and cannot be used unchanged for a routable deployment. Internal clients resolve the AD DNS zone through DC01/DC02. Exchange and SYNC01 rely on domain DNS and Kerberos/LDAP. Cloud identities cross the synchronization boundary; authentication may be password hash sync, pass-through authentication, or federation only after the chosen design is validated. Never infer that directory synchronization itself provides SSO.

See [editable Mermaid architecture](assets/diagrams/enterprise-topology.mmd). Each project documents its own failure and recovery paths.
