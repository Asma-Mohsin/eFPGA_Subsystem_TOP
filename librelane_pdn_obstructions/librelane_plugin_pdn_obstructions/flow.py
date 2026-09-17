from collections import defaultdict
from decimal import Decimal

from librelane.config.config import Config
from librelane.flows import Flow
from librelane.state import State


Classic = Flow.factory.get("Classic")


@Flow.factory.register()
class GenPDNObstructions(Classic):
    """Run the Classic flow with generated routing obstructions."""

    id = "GenPDNObstructions"
    name = "Generate PDN Routing Obstructions"

    def run(self, initial_state: State, **kwargs):
        if (
            self.config.get("ROUTING_OBSTRUCTIONS") is None
            and self.config.get("ROUTING_OBSTRUCTIONS") is not False
        ):
            self.config = self.config.copy(
                ROUTING_OBSTRUCTIONS=get_routing_obstructions(self.config)
            )

        return super().run(initial_state, **kwargs)


def get_routing_obstructions(config: Config):
    obstructions = config.get("ROUTING_OBSTRUCTIONS") or []
    _, _, width, height = config["DIE_AREA"]
    parsed_obstructions = defaultdict(list)

    for obstruction in obstructions:
        if len(obstruction) != 5:
            raise ValueError(
                f"Invalid obstruction {obstruction}. Each obstruction must contain "
                "a metal layer followed by four coordinates"
            )
        layer, *box = obstruction
        parsed_obstructions[layer].append(box)

    layers_spacing = {
        "Metal2": Decimal("0.21"),
        "Metal3": Decimal("0.21"),
        "Metal4": Decimal("0.21"),
        "TopMetal1": Decimal("1.64"),
    }

    for layer, spacing in layers_spacing.items():
        spacing_half = spacing / 2
        if layer not in parsed_obstructions:
            parsed_obstructions[layer].extend(
                [
                    (-spacing_half, -1, width, -spacing_half),
                    (0, height + spacing_half, width + spacing_half, height + 1),
                    (-1, -spacing_half, -spacing_half, height),
                    (width + spacing_half, 0, width + 1, height + spacing_half),
                ]
            )

            if layer == "TopMetal1":
                obstruction_width = (
                    2 * config["PDN_HWIDTH"] + config["PDN_HSPACING"]
                )
                stripe_start = config["PDN_HOFFSET"]
                while stripe_start < height:
                    parsed_obstructions[layer].append(
                        (
                            0,
                            stripe_start,
                            width,
                            stripe_start + obstruction_width,
                        )
                    )
                    stripe_start += config["PDN_HPITCH"]

    return [
        (layer, *box)
        for layer, boxes in parsed_obstructions.items()
        for box in boxes
    ]