package components;

import ceramic.LdtkData.LdtkEntityInstance;
import ceramic.Component;
import ceramic.Entity;
import entities.Character;

class AbilitiesComponent extends Entity implements Component {
    @entity var character:Character;

    var abilityComponents:Array<Component> = [];

    public function new(ldtkEntity: LdtkEntityInstance) {
        super();
        
        var abilities:Array<Dynamic> = [];
        for (fieldInstance in ldtkEntity.fieldInstances) {
            switch fieldInstance.def.identifier {
                case "abilities":
                    abilities = fieldInstance.value;
            }
        }

        for (a in abilities) {
            var c = newAbilityComponent(a);
            if (c != null) {
                abilityComponents.push(c);
            }
        }
    }

    static function newAbilityComponent(identifier: String): Component {
        switch identifier {
            case SpellComponent.identifier: return new SpellComponent();
        }

        return null;
    }

    function bindAsComponent() {
        for (c in abilityComponents) {
            character.component(null, c);
        }
    }
}