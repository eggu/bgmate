package com.kurt.bgmate.presentation.common

import androidx.compose.animation.animateColorAsState
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.selection.toggleable
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.Icon
import androidx.compose.material3.LocalContentColor
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ProvideTextStyle
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.kurt.bgmate.ui.theme.BGMateTheme

@Composable
fun FilterChip(
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    label: @Composable () -> Unit,
) {
    val containerColor by animateColorAsState(
        targetValue = if (selected) {
            MaterialTheme.colorScheme.primary
        } else {
            MaterialTheme.colorScheme.surfaceVariant
        },
        label = "filter_chip_container"
    )
    val contentColor by animateColorAsState(
        targetValue = if (selected) {
            MaterialTheme.colorScheme.onPrimary
        } else {
            MaterialTheme.colorScheme.onSurfaceVariant
        },
        label = "filter_chip_content"
    )
    val borderColor by animateColorAsState(
        targetValue = if (selected) {
            MaterialTheme.colorScheme.primary
        } else {
            MaterialTheme.colorScheme.outline.copy(alpha = 0.6f)
        },
        label = "filter_chip_border"
    )

    Surface(
        modifier = modifier
            .clip(CircleShape)
            .toggleable(
                value = selected,
                enabled = enabled,
                role = Role.Checkbox,
                onValueChange = { onClick() }
            ),
        shape = CircleShape,
        color = containerColor,
        contentColor = contentColor,
        tonalElevation = if (selected) 2.dp else 0.dp,
        shadowElevation = 0.dp,
        border = androidx.compose.foundation.BorderStroke(1.dp, borderColor)
    ) {
        Row(
            modifier = Modifier
                .defaultMinSize(minHeight = 36.dp)
                .padding(FilterChipContentPadding),
            verticalAlignment = Alignment.CenterVertically
        ) {
            if (selected) {
                Icon(
                    imageVector = Icons.Default.Check,
                    contentDescription = null,
                    modifier = Modifier
                        .padding(end = 6.dp)
                        .size(16.dp),
                    tint = contentColor
                )
            }
            ProvideTextStyle(MaterialTheme.typography.labelLarge) {
                label()
            }
        }
    }
}

private val FilterChipContentPadding = PaddingValues(
    horizontal = 14.dp,
    vertical = 8.dp
)

@Preview(showBackground = true)
@Composable
private fun FilterChipPreview() {
    BGMateTheme {
        Row(
            modifier = Modifier.padding(16.dp)
        ) {
            FilterChip(
                selected = true,
                onClick = {}
            ) {
                Text("전략")
            }
            FilterChip(
                selected = false,
                onClick = {},
                modifier = Modifier.padding(start = 8.dp)
            ) {
                Text(
                    text = "파티",
                    color = LocalContentColor.current
                )
            }
        }
    }
}
