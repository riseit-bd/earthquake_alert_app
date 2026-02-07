package wireguard

import (
	"testing"
)

func TestNewInterface(t *testing.T) {
	config := Config{
		PrivateKey: "privkey",
		PublicKey:  "pubkey",
		ListenPort: 51820,
		Endpoint:   "1.2.3.4:51820",
	}
	name := "wg0"
	iface := NewInterface(name, config)

	if iface.Name != name {
		t.Errorf("Expected name %s, got %s", name, iface.Name)
	}

	if iface.Config.PrivateKey != config.PrivateKey {
		t.Errorf("Expected PrivateKey %s, got %s", config.PrivateKey, iface.Config.PrivateKey)
	}
}

func TestInterfaceUp(t *testing.T) {
	config := Config{}
	iface := NewInterface("wg0", config)
	err := iface.Up()
	if err != nil {
		t.Errorf("Expected no error from Up(), got %v", err)
	}
}
